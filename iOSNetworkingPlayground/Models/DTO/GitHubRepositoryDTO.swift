//
//  GitHubRepositoryDTO.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

struct GitHubRepositoryDTO: Decodable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let stargazers_count: Int
    let updated_at: String
}
