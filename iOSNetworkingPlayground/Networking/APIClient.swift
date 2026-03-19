//
//  APIClient.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 27/02/26.
//

import Foundation

final class APIClient {
    private let urlSession: URLSession
    private let baseURL: URL
    private let decoder = JSONDecoder()

    init(urlSession: URLSession, baseURL: URL = URL(string: "https://api.github.com")!) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }

    func request<ResponseType: Decodable>(
        _ endpoint: Endpoint,
        responseType: ResponseType.Type
    ) async throws -> ResponseType {
        let request = try buildRequest(endpoint: endpoint)

        DebugLog.message("➡️ Request: \(request.httpMethod ?? "?") \(request.url?.absoluteString ?? "nil")")
        DebugLog.object(request.allHTTPHeaderFields ?? [:])

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch let urlError as URLError {
            if urlError.code == .cancelled {
                try logAndThrow(.cancelled)
            }
            try logAndThrow(.transport(urlError))
        } catch is CancellationError {
            try logAndThrow(.cancelled)
        } catch {
            try logAndThrow(.unknown)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            try logAndThrow(.unknown)
        }

        let statusCode = httpResponse.statusCode
        DebugLog.message("⬅️ Response: \(statusCode) (\(data.count) bytes)")

        guard (200...299).contains(statusCode) else {
            try logAndThrow(.server(statusCode: statusCode, data: data))
        }

        do {
            return try decoder.decode(ResponseType.self, from: data)
        } catch {
            try logAndThrow(.decoding)
        }
    }

    private func buildRequest(endpoint: Endpoint) throws -> URLRequest {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }

        urlComponents.path = endpoint.path
        if !endpoint.queryItems.isEmpty {
            urlComponents.queryItems = endpoint.queryItems
        }

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("NetworkingPlaygroundApp", forHTTPHeaderField: "User-Agent")
        return request
    }

    private func logAndThrow(_ error: NetworkError) throws -> Never {
        DebugLog.object(error)
        throw error
    }
}
