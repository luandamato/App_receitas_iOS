//
//  ForgotPasswordVM.swift
//  Recipes
//
//  Created by Luan Damato on 17/10/25.
//

import Foundation

protocol ForgotPasswordViewModelProtocol {
    var controller: ForgotPasswordControllerProtocol? { get set }
    func sendEmail(email: String)
    var emailError: String? { get }
    var genericError: String? { get }
}

class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    weak var controller: ForgotPasswordControllerProtocol?

    private(set) var emailError: String?
    private(set) var genericError: String?

    func sendEmail(email: String) {
        guard validate(email: email) else { return }
        
        let body = ForgotPasswordRequest(email: email)
        APIClient.shared.request(
            endPoint: .recoverPassword,
            method: .post,
            body: body,
            onSuccess: { (response: EmptyResponse) in
                self.controller?.setLoading(visible: false)
                self.controller?.backToLogin()
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false)
                self.genericError = errorMessage
                self.controller?.updateErros()
            }
        )
        
        controller?.backToLogin()
    }
    
    private func validate(email: String) -> Bool {
        emailError = nil
        genericError = nil

        // valida e-mail
        if email.isEmpty {
            emailError = String.stringFor(text: .requiredField)
        } else if !isValidEmail(email) {
            emailError = String.stringFor(text: .invalidEmail)
        }
        
        controller?.updateErros()
        return emailError == nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

