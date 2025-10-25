//
//  ImagePicker.swift
//  Recipes
//
//  Created by Luan Damato on 24/10/25.


import SwiftUI
import PhotosUI

struct RecipePhotoPickerView: View {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    var existingImageName: String?

    var body: some View {
        Button(action: { showImagePicker = true }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColorSUI.divider, lineWidth: 1)
                    .frame(height: 180)

                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else if let imageName = existingImageName,
                          let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    VStack {
                        Image(systemName: "camera")
                            .font(.system(size: 32))
                            .foregroundColor(AppColorSUI.primaryButton)
                        Text("Adicionar Foto")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}
