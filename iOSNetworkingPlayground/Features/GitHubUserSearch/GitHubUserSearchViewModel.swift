//
//  GitHubUserSearchViewModel.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 18/03/26.
//

import Foundation
import Combine

enum LoadState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}

struct GitHubUserSearchScreenModel: Equatable {
    let profile: GitHubUserProfile
    let repositories: [GitHubRepositorySummary]
}

@MainActor
final class GitHubUserSearchViewModel: ObservableObject {
    @Published var username: String = ""
    @Published private(set) var state: LoadState<GitHubUserSearchScreenModel> = .idle

    private let repository: GitHubRepositoryProtocol
    private var currentTask: Task<Void, Never>?

    init(repository: GitHubRepositoryProtocol) {
        self.repository = repository
    }

    var isSearchDisabled: Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func search() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUsername.isEmpty else { return }

        currentTask?.cancel()
        state = .loading

        currentTask = Task { [weak self] in
            guard let self else { return }

            do {
                let profile = try await repository.getUserProfile(username: trimmedUsername)
                let repositories = try await repository.getUserRepositories(username: trimmedUsername)

                if Task.isCancelled { return }

                let screenModel = GitHubUserSearchScreenModel(profile: profile, repositories: repositories)
                state = .loaded(screenModel)

            } catch let networkError as NetworkError {
                if networkError == .cancelled { return }
                state = .failed(mapNetworkErrorToMessage(networkError))
            } catch {
                state = .failed("Unexpected error.")
            }
        }
    }

    private func mapNetworkErrorToMessage(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL."
        case .transport(let urlError):
            if urlError.code == .notConnectedToInternet {
                return "No internet connection."
            }
            if urlError.code == .timedOut {
                return "The request timed out."
            }
            return "Connection error."
        case .server(let statusCode, _):
            if statusCode == 404 {
                return "User not found."
            }
            return "Server error (\(statusCode))."
        case .decoding:
            return "Could not decode server response."
        case .cancelled:
            return "Cancelled."
        case .unknown:
            return "Unknown error."
        }
    }
}
