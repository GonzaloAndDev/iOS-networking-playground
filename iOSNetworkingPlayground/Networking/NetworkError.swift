//
//  NetworkError.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 27/02/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case transport(URLError)
    case server(statusCode: Int, data: Data)
    case decoding
    case cancelled
    case unknown
}
