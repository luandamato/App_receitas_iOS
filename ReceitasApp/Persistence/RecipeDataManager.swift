//
//  RecipeDataManager.swift
//  Recipes
//
//  Created by Luan Damato on 02/11/25.
//

import UIKit
import CoreData

class RecipeCoreDataManager {
    static let shared = RecipeCoreDataManager()
    private let context: NSManagedObjectContext

    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    // MARK: - Criar
    func create(recipeData: Recipe){
        let recipe = RecipeEntity(context: context)
        recipe.id = recipeData.id
        recipe.name = recipeData.name
        recipe.description_ = recipeData.description
        recipe.images = recipeData.images as NSObject?
        recipe.owner = recipeData.owner
        recipe.ownerId = recipeData.ownerId
        recipe.date = recipeData.date
        recipe.ingredients = recipeData.ingredients as NSObject?
        recipe.preparation = recipeData.preparation
        do {
            try context.save()
        } catch {
            print("Erro ao salvar receita: \(error)")
        }
    }

    // MARK: - Obter (por id)
    func get(byId id: String) -> RecipeEntity? {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(request).first
        } catch {
            print("Erro ao buscar receita: \(error)")
            return nil
        }
    }

    // MARK: - Obter todos
    func getAll() -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao buscar receitas: \(error)")
            return []
        }
    }

    // MARK: - Editar
    func update(recipe: RecipeEntity, with data: Recipe) -> Bool {
        recipe.name = data.name
        recipe.description_ = data.description
        recipe.images = data.images as NSObject?
        recipe.owner = data.owner
        recipe.ownerId = data.ownerId
        recipe.date = data.date
        recipe.ingredients = data.ingredients as NSObject?
        recipe.preparation = data.preparation
        do {
            try context.save()
            return true
        } catch {
            print("Erro ao atualizar receita: \(error)")
            return false
        }
    }

    // MARK: - Deletar
    func delete(recipe: RecipeEntity) -> Bool {
        context.delete(recipe)
        do {
            try context.save()
            return true
        } catch {
            print("Erro ao deletar receita: \(error)")
            return false
        }
    }
}

// Exemplo de uso:
//
//let newRecipeData = Recipe(
//    id: "1",
//    name: "Bolo",
//    description: "Bolo simples",
//    images: ["img1.png"],
//    owner: "Maria",
//    ownerId: "123",
//    date: "2024-06-01",
//    ingredients: ["Farinha", "Ovo"],
//    preparation: "Misture tudo"
//)
//
//let newRecipe = RecipeCoreDataManager.shared.create(recipeData: newRecipeData)
//let allRecipes = RecipeCoreDataManager.shared.getAll()
//if let foundRecipe = RecipeCoreDataManager.shared.get(byId: "1") {
//    print(foundRecipe.name)
//}
//if let foundRecipe = RecipeCoreDataManager.shared.get(byId: "1") {
//    var updatedData = newRecipeData
//    updatedData.name = "Bolo de Chocolate"
//    _ = RecipeCoreDataManager.shared.update(recipe: foundRecipe, with: updatedData)
//}
//if let foundRecipe = RecipeCoreDataManager.shared.get(byId: "1") {
//    _ = RecipeCoreDataManager.shared.delete(recipe: foundRecipe)
//}
