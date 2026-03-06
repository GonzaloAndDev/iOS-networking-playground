//
//  GitHubRepositoryMapper.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

enum GitHubRepositoryMapper {
    static func map(_ dto: GitHubRepositoryDTO) -> GitHubRepositorySummary? {
        guard let updatedAt = GitHubDateParser.parseISO8601Date(dto.updated_at) else {
            return nil
        }
        
        return GitHubRepositorySummary(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            language: dto.language,
            stars: dto.stargazers_count,
            updatedAt: updatedAt
        )
    }
}
