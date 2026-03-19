//
//  GitHubUserProfileDTO.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

struct GitHubUserProfileDTO: Decodable {
    let id: Int
    let name: String?
    let login: String
    let bio: String?
    let avatar_url: String?
    let followers: Int
    let following: Int
}
