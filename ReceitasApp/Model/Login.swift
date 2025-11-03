//
//  Login.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

import Foundation

struct refreshTokenRequest: Codable {
    let refresh_token: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let expiresAt: Int
    let refreshToken: String
    var user: User
    let weakPassword: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case user
        case weakPassword = "weak_password"
    }
}

struct User: Codable {
    let id: String
    let aud: String
    let role: String
    let email: String
    let emailConfirmedAt: String?
    let phone: String?
    let confirmedAt: String?
    let lastSignInAt: String?
    let appMetadata: AppMetadata
    let userMetadata: UserMetadata
    let identities: [Identity]
    let createdAt: String?
    let updatedAt: String?
    let isAnonymous: Bool

    enum CodingKeys: String, CodingKey {
        case id, aud, role, email, phone, identities
        case emailConfirmedAt = "email_confirmed_at"
        case confirmedAt = "confirmed_at"
        case lastSignInAt = "last_sign_in_at"
        case appMetadata = "app_metadata"
        case userMetadata = "user_metadata"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isAnonymous = "is_anonymous"
    }
}

struct AppMetadata: Codable {
    let provider: String
    let providers: [String]
}

struct UserMetadata: Codable {
    let bio: String?
    let username: String?
    let email: String?
    let emailVerified: Bool?
    let nascimento: String?
    let nome: String?
    let phoneVerified: Bool?
    let sub: String?
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case username, bio, email, nascimento, nome, sub
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case avatarUrl = "avatar_url"
    }
}

struct Identity: Codable {
    let identityId: String
    let id: String
    let userId: String
    let identityData: IdentityData
    let provider: String
    let lastSignInAt: String?
    let createdAt: String?
    let updatedAt: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case identityId = "identity_id"
        case id
        case userId = "user_id"
        case identityData = "identity_data"
        case provider
        case lastSignInAt = "last_sign_in_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case email
    }
}

struct IdentityData: Codable {
    let documento: String?
    let email: String?
    let emailVerified: Bool?
    let nascimento: String?
    let nome: String?
    let phoneVerified: Bool?
    let sub: String?

    enum CodingKeys: String, CodingKey {
        case documento, email, nascimento, nome, sub
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
    }
}
