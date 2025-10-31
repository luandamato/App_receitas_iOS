//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Luan Damato on 23/10/25.
//

import SwiftUI

struct IngredientsListView: View {
    let ingredients: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(String.stringFor(text: .ingredients)).fontWeight(.semibold)
                .font(.system(size: 15))
            ForEach(ingredients, id: \.self) { ingredient in
                HStack(alignment: .top) {
                    Text("•")
                    CustomLabelView(text: ingredient, type: .body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }.padding(.top)
    }
}

struct RecipeHeader: View {
    let meal: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            CustomLabelView(text: meal.name, type: .title, textSize: 20)
                .fixedSize(horizontal: false, vertical: true)
            
            CustomLabelView(text: "\(String.stringFor(text: .publishedBy)) \(meal.owner ?? "") \(String.stringFor(text: .on)) \(convertISOToBR(meal.date) ?? "")",
                            type: .body, textSize: 12)
            .fixedSize(horizontal: false, vertical: true)
            
            CustomLabelView(text: meal.description, type: .body)
                .fixedSize(horizontal: false, vertical: true).padding(.top, 12)
        }
    }
    
    private func convertISOToBR(_ isoString: String?) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: isoString ?? "") {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return outputFormatter.string(from: date)
        }
        return nil
    }
}

struct RefeicaoView: View {
    let refeicao: Recipe
    @State private var isLoading = false
    @State private var searchText = ""
    @State private var nome = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                URLImage(url: URL(string: refeicao.images?.first ?? ""))
                
                VStack(alignment: .leading, spacing: 16) {
                    RecipeHeader(meal: refeicao)
                    IngredientsListView(ingredients: refeicao.ingredients ?? [])
                    
                    Text(String.stringFor(text:.preparation)).fontWeight(.semibold).font(.system(size: 15)).padding(.top)
                    CustomLabelView(text: refeicao.preparation, type: .body)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }.padding().frame(maxWidth: .infinity, alignment: .leading)
            }
        }.background(AppColorSUI.background)
    }
}

//struct RefeicaoView_Previews: PreviewProvider {
//    static var previews: some View {
//        RefeicaoView(refeicao: Recipe(name: "Nome",
//                                      description: "asdasndjsnfdsf dsjf dsjf djf dsjf djs fdsj fdsf meio sdjfsd fdjs fdsjf sdj fjdsfsdjf", imageName: "cake",
//                                      ingredients: ["infrediente 1 ","ingredient2"]))
//    }
//}
