//
//  GitHubRepository.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 11/03/26.
//

import Foundation

protocol GitHubRepositoryProtocol {
    func getUserProfile(username: String) async throws -> GitHubUserProfile
    func getUserRepositories(username: String) async throws -> [GitHubRepositorySummary]
}

final class GitHubRepository: GitHubRepositoryProtocol {
    private let service: GitHubServiceProtocol

    init(service: GitHubServiceProtocol) {
        self.service = service
    }

    func getUserProfile(username: String) async throws -> GitHubUserProfile {
        let dto = try await service.fetchUserProfile(username: username)
        return GitHubUserMapper.map(dto)
    }

    func getUserRepositories(username: String) async throws -> [GitHubRepositorySummary] {
        let dtos = try await service.fetchUserRepositories(username: username)
        return dtos.compactMap(GitHubRepositoryMapper.map)
    }
}
