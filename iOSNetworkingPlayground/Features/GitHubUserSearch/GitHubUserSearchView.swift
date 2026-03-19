//
//  GitHubUserSearchView.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 18/03/26.
//

import SwiftUI

struct GitHubUserSearchView: View {
    @StateObject private var viewModel: GitHubUserSearchViewModel

    init(viewModel: GitHubUserSearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    TextField("GitHub username", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Button("Search") {
                        viewModel.search()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isSearchDisabled)
                }

                content
            }
            .padding()
            .navigationTitle("Networking Playground")
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Type a username and tap Search.")
                .foregroundStyle(.secondary)

        case .loading:
            ProgressView("Loading...")

        case .loaded(let screenModel):
            List {
                profileSection(screenModel.profile)

                if screenModel.repositories.isEmpty {
                    Text("No public repositories found.")
                        .foregroundStyle(.secondary)
                } else {
                    repositoriesSection(screenModel.repositories)
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                viewModel.search()
            }

        case .failed(let message):
            VStack(spacing: 12) {
                Text(message)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    viewModel.search()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 24)
        }
    }

    private func profileSection(_ profile: GitHubUserProfile) -> some View {
        Section("Profile") {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: profile.avatarURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.displayName)
                        .font(.headline)

                    if let bio = profile.bio, !bio.isEmpty {
                        Text(bio)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        Text("Followers: \(profile.followers)")
                        Text("Following: \(profile.following)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func repositoriesSection(_ repositories: [GitHubRepositorySummary]) -> some View {
        Section("Repositories") {
            ForEach(repositories) { repository in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(repository.name)
                            .font(.headline)
                        Spacer()
                        Text("★ \(repository.stars)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if let description = repository.description, !description.isEmpty {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        if let language = repository.language, !language.isEmpty {
                            Text(language)
                        }
                        Text("Updated: \(repository.updatedAtFormatted)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
}
