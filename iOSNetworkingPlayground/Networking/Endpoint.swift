//
//  Endpoint.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 27/02/26.
//

import Foundation

struct Endpoint {
    let method:HTTPMethod
    let path: String
    let queryItems: [URLQueryItem]
    
    init(
        method:HTTPMethod,
        path: String,
        queryItems: [URLQueryItem] = []
    ) {
        self.method = method
        self.path  = path
        self.queryItems =  queryItems
    }
}
