//
//  WelcomeVC.swift
//  ReceitasApp
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit

class WelcomeVC: UIViewController {

    // MARK: - Subviews\
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcome_bg") // Substitua pelo nome da sua imagem
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcome_logo") // Substitua pelo nome da sua imagem
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        view.backgroundColor = AppColor.background
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            // Background cobre tudo
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Título centralizado na tela
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Login button
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -16),

            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)

        ])
    }
    
    private func onLoginClick() {
        registerButton.habilitado.toggle()
    }
    
    private func onRegisterClcik() {
        loginButton.habilitado.toggle()
    }

}
