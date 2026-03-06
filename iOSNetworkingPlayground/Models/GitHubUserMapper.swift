//
//  GitHubUserMapper.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

enum gitHubUserMapper {
    static func map(_ dto: GitHubUserProfileDTO) -> GitHubUserProfile {
        let displayName = (dto.name?.isEmpty == false) ? dto.name! : dto.login
        let avatarURL = dto.avatar_url.flatMap(URL.init(string:))
        
        return GitHubUserProfile(
            id: dto.id,
            displayName: displayName,
            bio: dto.bio,
            avatarURL: avatarURL,
            followers: dto.followers,
            following: dto.following
        )
    }
}
