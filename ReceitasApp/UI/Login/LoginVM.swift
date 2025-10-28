//
//  LoginVM.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation

protocol LoginViewModelProtocol {
    var controller: LoginControllerProtocol? { get set }
    func login(email: String, password: String)
    var emailError: String? { get }
    var passwordError: String? { get }
    var genericError: String? { get }
}

class LoginViewModel: LoginViewModelProtocol {
    weak var controller: LoginControllerProtocol?

    private(set) var emailError: String?
    private(set) var passwordError: String?
    private(set) var genericError: String?

    func login(email: String, password: String) {
        guard validate(email: email, password: password) else { return }

        controller?.setLoading(visible: true)
        let userRequest = LoginRequest(email: email, password: password)
        controller?.setLoading(visible: true)
        APIClient.shared.request(
            endPoint: .login,
            method: .post,
            body: userRequest,
            headers: ["Custom-Header": "Valor"],
            onSuccess: { (userResponse: AuthResponse) in
                self.controller?.setLoading(visible: true)
                self.controller?.gotoHome()
                print(userResponse.user.userMetadata.nome ?? "")
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false)
                self.genericError = errorMessage
                self.controller?.updateErros()
                print("Erro:", errorMessage, "Status code:", statusCode ?? 0)
            }
        )
    }
    
    private func validate(email: String, password: String) -> Bool {
        emailError = nil
        passwordError = nil
        genericError = nil

        // valida e-mail
        if email.isEmpty {
            emailError = String.stringFor(text: .requiredField)
        } else if !isValidEmail(email) {
            emailError = String.stringFor(text: .invalidEmail)
        }

        // valida senha
        if password.count < 4 {
            passwordError = String.stringFor(text: .passwordMinLength)
        }
        
        controller?.updateErros()
        return emailError == nil && passwordError == nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

