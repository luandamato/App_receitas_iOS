//
//  OnlineImageView.swift
//  Recipes
//
//  Created by Luan Damato on 30/10/25.
//

import SwiftUI
struct URLImage: View {
    let url: URL?

    @State private var image: Image? = nil
    @State private var hasError = false

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } else if hasError {
                Text("Erro ao carregar imagem")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            } else {
                ProgressView()
                    .onAppear(perform: loadImage)
            }
        }
    }

    private func loadImage() {
        guard let url else {
            print("erro ao carregar url da imagem")
            DispatchQueue.main.async {
                self.hasError = true
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            } else {
                DispatchQueue.main.async {
                    self.hasError = true
                }
            }
        }.resume()
    }
}
