//
//  ProfileModel.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import Foundation

struct Profile: Codable, Hashable {
    let user: UserProfile
    let repositories: [Repository]
}

struct UserProfile: Codable, Hashable {
    let login: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

struct Repository: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id, name, language
    }
}
