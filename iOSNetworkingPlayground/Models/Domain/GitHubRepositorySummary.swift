//
//  GitHubRepositorySummary.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

struct GitHubRepositorySummary: Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let stars: Int
    let updatedAt: Date

    var updatedAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: updatedAt)
    }
}
