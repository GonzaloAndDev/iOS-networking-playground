//
//  GitHubUserProfile.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

struct GitHubUserProfile: Equatable {
    let id: Int
    let displayName: String
    let bio: String?
    let avatarURL: URL?
    let followers: Int
    let following: Int
}
