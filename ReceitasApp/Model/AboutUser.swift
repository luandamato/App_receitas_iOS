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
}
