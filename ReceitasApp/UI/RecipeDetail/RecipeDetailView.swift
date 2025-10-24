//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Luan Damato on 23/10/25.
//

import SwiftUI

struct RefeicaoView: View {
    let refeicao: Recipe
    @State private var isLoading = false
    @State private var searchText = ""
    @State private var nome = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Image(refeicao.imageName ?? "").resizable().aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 16) {
                    CustomLabelView(text: refeicao.name, type: .title)
                        .fixedSize(horizontal: false, vertical: true)
                    CustomLabelView(text: refeicao.description, type: .body)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    CustomEditTextView(
                        text: $nome,
                        title: "Nome",
                        placeholder: "Digite seu nome",
                        type: .normal
                    ).frame(minHeight: 80)
                    
                    CustomEditTextView(
                        text: $searchText,
                        title: "Buscar receita",
                        placeholder: "Digite algooooooo...",
                        type: .password,
                        onSearchLocal: { value in
                            print("Busca local: \(value)")
                        },
                        onSearchRemote: { value in
                            print("Busca remota: \(value)")
                        }
                    ).frame(minHeight: 80)
                    
                    CustomButtonView(text: "Ver Receita", type: .primary,
                                     onTap: {
                        print("Botão clicado!")
                        isLoading = true
                        // Simula uma chamada de rede
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    },
                                     isLoading: $isLoading)
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    
                    CustomButtonView(text: "Ver Receita", type: .secondary,
                                     onTap: {
                        print("Botão clicado!")
                    },
                                     isLoading: $isLoading)
                    .frame(maxWidth: .infinity, maxHeight: 48)
                }.padding().frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct RefeicaoView_Previews: PreviewProvider {
    static var previews: some View {
        RefeicaoView(refeicao: Recipe(name: "nome",
                                      description: "asdasndjsnfdsf dsjf dsjf djf dsjf djs fdsj fdsf meio sdjfsd fdjs fdsjf sdj fjdsfsdjf", imageName: "cake"))
    }
}
