//
//  ImagePicker.swift
//  Recipes
//
//  Created by Luan Damato on 24/10/25.

import UIKit
import SwiftUI
import PhotosUI

struct RecipePhotoPickerView: View {
    @Binding var image: UIImage?
    @State private var showSourceActionSheet = false
    @State private var showCameraPicker = false
    @State private var showGalleryPicker = false

    var existingImageName: String?

    var body: some View {
        Button(action: { showSourceActionSheet = true }) {
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
                        Text(String.stringFor(text: .addPhoto))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        // 🔽 Ação ao tocar
        .confirmationDialog(String.stringFor(text: .selectPhoto), isPresented: $showSourceActionSheet) {
            Button(String.stringFor(text: .fromCamera)) { showCameraPicker = true }
            Button(String.stringFor(text: .fromGallery)) { showGalleryPicker = true }
            Button(String.stringFor(text: .cancel), role: .cancel) {}
        }
        // 📷 Abre a câmera
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(image: $image)
        }
        // 🖼️ Abre a galeria
        .sheet(isPresented: $showGalleryPicker) {
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

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = image
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
