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
    var imageName: String?
    var owner: String? = ""
    var ownerId: String? = ""
    var date: String? = ""
    var ingredients: [String]? = []
    var preparation: String? = ""
    
    init(id: String, name: String, description: String? = nil, imageName: String? = nil, owner: String? = nil, date: String? = nil, ingredients: [String]? = nil, preparation: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.owner = owner
        self.date = date
        self.ingredients = ingredients
        self.preparation = preparation
    }
    
    init(name: String, description: String?, imageName: String?, ingredients: [String]) {
        self.name = name
        self.description = description
        self.imageName = imageName
        self.ingredients = ingredients
    }
}
