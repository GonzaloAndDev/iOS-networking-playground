//
//  GitHubDateParser.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 05/03/26.
//

import Foundation

enum GitHubDateParser {
    static func parseISO8601Date(_ value: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: value){
            return date
        }
        
        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]
        return fallbackFormatter.date(from: value)
    }
}
