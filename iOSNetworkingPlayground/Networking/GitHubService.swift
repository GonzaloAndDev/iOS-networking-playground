//
//  GitHubService.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 11/03/26.
//

import Foundation

protocol GitHubServiceProtocol {
    func fetchUserProfile(username: String) async throws -> GitHubUserProfileDTO
    func fetchUserRepositories(username: String) async throws ->[GitHubRepositoryDTO]
}

final class GitHubService: GitHubServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchUserProfile(username: String) async throws ->GitHubUserProfileDTO {
        try await apiClient.request(GitHubEndpoints.userProfile(username: username), responseType: GitHubUserProfileDTO.self)
    }
    
    func fetchUserRepositories(username: String) async throws -> [GitHubRepositoryDTO] {
        try await apiClient.request(GitHubEndpoints.userRepositories(username: username), responseType: [GitHubRepositoryDTO].self)
    }
}
