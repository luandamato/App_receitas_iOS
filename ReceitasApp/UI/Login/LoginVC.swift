//
//  LoginVC.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit

class LoginVC: BaseViewController {

    // MARK: - Subviews\
    private lazy var lblTitle: CustomLabel = {
        let view = CustomLabel(text: "Bem-vindo de volta!", type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtEmail: CustomEditText = {
        let view = CustomEditText(titulo: "Email", placeholder: "Preencha com seu email")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtPassword: CustomEditText = {
        let view = CustomEditText(titulo: "Senha", placeholder: "Preencha com sua senha")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.senha = true
        return view
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(type: .primary, text: NSLocalizedString("signin", comment: "")) { [weak self] in
            self?.onLoginClick()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerButton: CustomButton = {
        let button = CustomButton(type: .secondary, text: NSLocalizedString("signup", comment: ""), onTap: {
            self.onRegisterClcik()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(lblTitle)
        view.addSubview(txtEmail)
        view.addSubview(txtPassword)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            lblTitle.heightAnchor.constraint(equalToConstant: 40),
            
            txtEmail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.bigMargin),
            txtEmail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtEmail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
        
            txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: SizeConstants.smallMargin),
            txtPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            // Login button
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -SizeConstants.smallMargin),

            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SizeConstants.mediumMargin)

        ])
    }
    
    private func onLoginClick() {
        loginButton.setLoading(visible: true)
        registerButton.setLoading(visible: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loginButton.setLoading(visible: false)
            self.registerButton.setLoading(visible: false)
        }
    }
    
    private func onRegisterClcik() {
        setLoading(visible: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.setLoading(visible: false)
        }
    }

}
