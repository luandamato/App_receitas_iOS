//
//  Recipe.swift
//  Recipes
//
//  Created by Luan Damato on 22/10/25.
//

import Foundation

struct Recipe: Codable {
    var id: String = ""
    var name: String
    var description: String?
    var images: [String]?
    var owner: String? = ""
    var ownerId: String? = ""
    var date: String? = ""
    var ingredients: [String]? = []
    var preparation: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, images, owner, ownerId, ingredients, preparation
        case date = "created_at"
    }
}
