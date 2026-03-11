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
    
    init(urlSession: URLSession, baseURL: URL = URL(string: "https://api.github.com")!) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }
    
    func request<ResponseType: Decodable> (
        _ endpoint: Endpoint,
        responseType: ResponseType.Type) async throws -> ResponseType {
            let request = try buildRequest(endpoint: endpoint)
            
            do {
                let (data, response) = try await urlSession.data(for: request)
                
                if Task.isCancelled {
                    throw NetworkError.cancelled
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown
                }
                
                let statusCode = httpResponse.statusCode
                guard (200...299).contains(statusCode) else {
                    throw NetworkError.server(statusCode: statusCode, data: data)
                }
                
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(ResponseType.self, from: data)
                } catch {
                    throw NetworkError.decoding
                }
                
            } catch let urlError as URLError {
                if urlError.code == .cancelled {
                    throw NetworkError.cancelled
                }
                throw NetworkError.transport(urlError)
            } catch is CancellationError {
                throw NetworkError.cancelled
            } catch {
                throw NetworkError.unknown
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
}
