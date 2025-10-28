//
//  AboutUserVM.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

import Foundation
import UIKit

protocol AboutUserViewModelProtocol {
    var controller: AboutUserControllerProtocol? { get set }
    func update(username: String, bio: String, photo: UIImage?)
    var bioError: String? { get }
    var usernameError: String? { get }
    var genericError: String? { get }
}

class AboutUserViewModel: AboutUserViewModelProtocol {
    weak var controller: AboutUserControllerProtocol?

    private(set) var bioError: String?
    private(set) var usernameError: String?
    private(set) var genericError: String?
    private var imageData: Data?
    
    func update(username: String, bio: String, photo: UIImage?) {
        guard validate(username: username, bio: bio, photo: photo) else { return }
        self.controller?.gotoHome()
    }
    
    private func validate(username: String, bio: String, photo: UIImage?) -> Bool {
        bioError = nil
        usernameError = nil
        genericError = nil

        // valida e-mail
        if username.isEmpty {
            usernameError = String.stringFor(text: .requiredField)
        }
        
        if bio.count < 5 {
            bioError = String.stringFor(text: .tooShortBio)
        }
        else if bio.count > 500 {
            bioError = String.stringFor(text: .tooLongBio)
        }
        
        validImage(photo)
        controller?.updateErros()
        return bioError == nil && usernameError == nil && genericError == nil
    }
    
    private func validImage(_ image: UIImage?) {
        guard let image else { return }
        
        // Converte para JPEG (qualidade 0.8 é um bom equilíbrio)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            genericError = String.stringFor(text: .imageError)
            return
        }

        // Tamanho máximo 5MB (ajuste conforme necessário)
        let maxSizeInBytes = 5 * 1024 * 1024
        guard imageData.count <= maxSizeInBytes else {
            genericError = String.stringFor(text: .imageTooLarge)
            return
        }

        self.imageData = imageData
    }
}

