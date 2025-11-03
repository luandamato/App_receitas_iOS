//
//  SignupVM.swift
//  Recipes
//
//  Created by Luan Damato on 19/10/25.
//

import Foundation

protocol RegisterViewModelProtocol {
    var controller: RegisterControllerProtocol? { get set }
    func register(name: String, email: String, birthdate: String, password: String, confirmPasswrod: String)
    var nameError: String? { get }
    var emailError: String? { get }
    var birthdateError: String? { get }
    var passwordError: String? { get }
    var confirmPasswordError: String? { get }
    var genericError: String? { get }
}

class RegisterViewModel: RegisterViewModelProtocol {
    weak var controller: RegisterControllerProtocol?
    
    private(set) var nameError: String? = nil
    private(set) var emailError: String? = nil
    private(set) var birthdateError: String? = nil
    private(set) var passwordError: String? = nil
    private(set) var confirmPasswordError: String? = nil
    private(set) var genericError: String? = nil
    
    func register(name: String, email: String, birthdate: String, password: String, confirmPasswrod: String) {
        guard validate(name: name, email: email, birthdate: birthdate,
                       password: password, confirmPasswrod: confirmPasswrod)
        else { return }

        controller?.setLoading(visible: true)
        let body = RegisterRequest(email: email,
                                   password: password,
                                   data: RegisterData(nome: name, nascimento: convertDate(birthdate)))
        APIClient.shared.request(
            endPoint: .register,
            method: .post,
            body: body,
            onSuccess: { (userResponse: AuthResponse) in
                UserSessionManager.shared.saveUser(userResponse)
                self.controller?.setLoading(visible: false)
                self.controller?.gotoUserInfo()
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false)
                self.genericError = errorMessage
                self.controller?.updateErros()
            }
        )
    }
    
    private func validate(name: String, email: String, birthdate: String, password: String, confirmPasswrod: String) -> Bool {
        nameError = nil
        emailError = nil
        birthdateError = nil
        passwordError = nil
        confirmPasswordError = nil
        genericError = nil
        
        // valida nome
        if name.isEmpty {
            nameError = String.stringFor(text: .requiredField)
        } else if name.split(separator: " ").count <= 1 {
            nameError = String.stringFor(text: .fillFullName)
        }
        
        // valida e-mail
        if email.isEmpty {
            emailError = String.stringFor(text: .requiredField)
        } else if !isValidEmail(email) {
            emailError = String.stringFor(text: .invalidEmail)
        }
        
        // valida nascimento
        if birthdate.isEmpty {
            birthdateError = String.stringFor(text: .requiredField)
        } else if !isValidBirthdate(birthdate) {
            birthdateError = String.stringFor(text: .invalidBirthdate)
        }

        // valida senha
        if password.count < 4 {
            passwordError = String.stringFor(text: .passwordMinLength)
        }
        
        // valida confirmacao de senha
        if password != confirmPasswrod {
            confirmPasswordError = String.stringFor(text: .passwordsMustMatch)
        }
        
        controller?.updateErros()
        return [emailError, nameError, birthdateError, passwordError, confirmPasswordError].allSatisfy { $0 == nil }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func isValidBirthdate(_ dataStr: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.timeZone = TimeZone.current

        guard let dataNascimento = dateFormatter.date(from: dataStr) else {
            return false
        }

        let hoje = Date()
        let calendar = Calendar.current

        let idadeComponentes = calendar.dateComponents([.year, .month, .day], from: dataNascimento, to: hoje)
        guard let idade = idadeComponentes.year else {
            return false
        }
        
        if convertDate(dataStr).isEmpty {
            return false
        }

        if dataNascimento > hoje {
            return false
        }
        return idade >= 0 && idade <= 100
    }
    
    func convertDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        }
        return ""
    }
}

