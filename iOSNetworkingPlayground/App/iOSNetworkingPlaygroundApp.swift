//
//  iOSNetworkingPlaygroundApp.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 27/02/26.
//

import SwiftUI

@main
struct NetworkingPlaygroundApp: App {
    private let gitHubUserSearchViewModel: GitHubUserSearchViewModel

    init() {
        let urlSession = URLSession(configuration: .default)
        let apiClient = APIClient(urlSession: urlSession)
        let gitHubService = GitHubService(apiClient: apiClient)
        let gitHubRepository = GitHubRepository(service: gitHubService)
        self.gitHubUserSearchViewModel = GitHubUserSearchViewModel(repository: gitHubRepository)
    }

    var body: some Scene {
        WindowGroup {
            GitHubUserSearchView(viewModel: gitHubUserSearchViewModel)
        }
    }
}
