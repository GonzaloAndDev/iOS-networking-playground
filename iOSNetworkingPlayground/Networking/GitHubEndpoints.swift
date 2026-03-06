//
//  GitHubEndpoints.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 27/02/26.
//

import Foundation

enum GitHubEndpoints {
    static func userProfile(username: String) -> Endpoint {
        Endpoint(method: .get, path: "/users/\(username)")
    }

    static func userRepositories(username: String) -> Endpoint {
        Endpoint(
            method: .get,
            path: "/users/\(username)/repos",
            queryItems: [
                URLQueryItem(name: "per_page", value: "30"),
                URLQueryItem(name: "sort", value: "updated")
            ]
        )
    }
}
