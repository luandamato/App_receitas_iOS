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
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.controller?.setLoading(visible: false)
            if email == "teste@teste.com" && password == "1234" {
                self.controller?.gotoHome()
            }
            else if password == "12345" {
                self.passwordError = "Senha incorreta"
            }
            else {
                self.genericError = "Falha na conexão, tente novamente mais tarde"
            }
            self.controller?.updateErros()
         }
    }
    
    private func validate(email: String, password: String) -> Bool {
        emailError = nil
        passwordError = nil
        genericError = nil

        // valida e-mail
        if email.isEmpty {
            emailError = "Campo obrigatório"
        } else if !isValidEmail(email) {
            emailError = "E-mail inválido"
        }

        // valida senha
        if password.count < 4 {
            passwordError = "A senha deve ter pelo menos 4 caracteres"
        }
        
        controller?.updateErros()
        return emailError == nil && passwordError == nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

