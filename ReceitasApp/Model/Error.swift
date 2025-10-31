//
//  Error.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

struct APIErrorResponse: Codable {
    let msg: String
    let code: Int
    let error_code: String
}
