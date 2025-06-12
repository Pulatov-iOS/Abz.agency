//
//  Untitled.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let position_id: Int
    let registration_timestamp: Int
    let photo: String
}

struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let total_pages: Int
    let total_users: Int
    let count: Int
    let links: Links
    let users: [User]
}

struct Links: Codable {
    let next_url: String?
    let prev_url: String?
}

struct Position: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]?
}

struct TokenResponse: Codable {
    let success: Bool
    let token: String
}

struct SignUpResponse: Decodable {
    let success: Bool
    let message: String
    let fails: [String: [String]]?
}
