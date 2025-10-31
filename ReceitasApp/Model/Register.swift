//
//  Register.swift
//  Recipes
//
//  Created by Luan Damato on 29/10/25.
//

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let data: RegisterData
}

struct RegisterData: Codable {
    let nome: String
    let nascimento: String
}
