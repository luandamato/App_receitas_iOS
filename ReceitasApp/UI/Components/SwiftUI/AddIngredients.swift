//
//  AddIngredients.swift
//  Recipes
//
//  Created by Luan Damato on 25/10/25.
//

import SwiftUI

struct AddIngredientsView: View {
    @Binding var ingredients: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CustomLabelView(text: String.stringFor(text: .ingredients), type: .body)
                .font(.headline)
                .padding(.bottom, 4)

            ForEach(ingredients.indices, id: \.self) { idx in
                HStack {
                    TextField(String.stringFor(text: .ingredientHint), text: $ingredients[idx])
                        .padding()
                        .background(AppColorSUI.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(AppColorSUI.divider, lineWidth: 1)
                        )
                        .cornerRadius(5)
                    if ingredients.count > 1 {
                        Button(action: { ingredients.remove(at: idx) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

            Button(action: { ingredients.append("") }) {
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(AppColorSUI.primaryButton)
                    Text(String.stringFor(text: .addIngredient))
                        .fontWeight(.semibold)
                        .foregroundColor(AppColorSUI.primaryButton)
                }
            }
            .padding(.top, 4)
        }
    }
}
