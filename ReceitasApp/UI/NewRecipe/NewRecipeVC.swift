//
//  NewRecipeVC.swift
//  Recipes
//
//  Created by Luan Damato on 24/10/25.
//
import SwiftUI

struct AddRecipeView: View {
    // MARK: - Recebe a receita para edição (opcional)
    var existingRecipe: Recipe?

    // MARK: - Estados locais
    @State private var name = ""
    @State private var description = ""
    @State private var ingredients = [""]
    @State private var prepare = ""
    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: - Foto
                RecipePhotoPickerView(
                    image: $image,
                    existingImageName: existingRecipe?.imageName
                )
                
                // MARK: - Título
                CustomEditTextView(
                    text: $name,
                    title: "Nome da receita",
                    placeholder: "Bolo de chocolate",
                    type: .normal
                )
                .frame(minHeight: 80)

                // MARK: - Descrição
                CustomTextAreaView(
                    text: $description,
                    title: "Descrição",
                    characterLimit: 250
                )
                .frame(minHeight: 180)

                // MARK: - Ingredientes
                AddIngredientsView(ingredients: $ingredients)

                // MARK: - modo de preparo
                CustomTextAreaView(
                    text: $prepare,
                    title: "Modo de preparo",
                    showLimit: false
                )
                .frame(minHeight: 180)

                // MARK: - Salvar Receita
                
                CustomButtonView(text: existingRecipe == nil ? "Salvar Receita" : "Atualizar Receita",
                                 onTap: saveRecipe,
                                 isLoading: $isLoading)
            }
            .padding()
        }
        .onAppear {
            if let recipe = existingRecipe {
                populateFields(with: recipe)
            }
        }
    }

    // MARK: - Funções auxiliares
    func populateFields(with recipe: Recipe) {
        name = recipe.name
        description = recipe.description ?? ""
        ingredients = recipe.ingredients ?? [""]
        prepare = recipe.preparation ?? ""
    }

    func saveRecipe() {
        isLoading = true
        print(name)
        if let current = existingRecipe {
            let update = Recipe(
                id: current.id,
                name: name,
                description: description,
                imageName: "",
                owner: current.owner,
                date: current.date,
                ingredients: ingredients.filter { !$0.isEmpty },
                preparation: prepare
            )
            print("🔄 Atualiza receita \(update)")
        } else {
            let newRecipe = Recipe(
                id: "", name: name,
                description: description,
                imageName: "",
                ingredients: ingredients.filter { !$0.isEmpty },
                preparation: prepare
            )
            print("🆕 Nova receita \(newRecipe)")
        }
    }
}

// MARK: - Preview
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
