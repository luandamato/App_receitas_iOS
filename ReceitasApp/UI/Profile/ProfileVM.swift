//
//  ProfileVM.swift
//  Recipes
//
//  Created by Luan Damato on 30/10/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    var controller: ProfileControllerProtocol? { get set }
    func updateUser()
}

class ProfileViewModel: ProfileViewModelProtocol {
    weak var controller: ProfileControllerProtocol?

    private(set) var emailError: String?
    private(set) var passwordError: String?
    private(set) var genericError: String?

    func updateUser() {
        APIClient.shared.request(
            endPoint: .getLoggedUser,
            onSuccess: { (user: User) in
                UserSessionManager.shared.update(user: user)
                self.controller?.updateUser()
            },
            onError: { errorMessage, statusCode in
                print("Erro:", errorMessage, statusCode ?? 0)
            }
        )

    }
}
