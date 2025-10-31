//
//  ForgotPassword.swift
//  Recipes
//
//  Created by Luan Damato on 29/10/25.
//

struct ForgotPasswordRequest: Codable {
    let email: String
}

struct EmptyResponse: Codable { }
