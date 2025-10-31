//
//  AboutUser.swift
//  Recipes
//
//  Created by Luan Damato on 29/10/25.
//

struct AboutUserRequest: Codable {
    let data: AboutUserData
}

struct AboutUserData: Codable {
    let username: String
    let bio: String
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case username, bio
        case avatar = "avatar_url"
    }
}
