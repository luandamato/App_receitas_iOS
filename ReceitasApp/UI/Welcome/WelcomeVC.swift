//
//  WelcomeVC.swift
//  ReceitasApp
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes

class WelcomeVC: BaseViewController {

    // MARK: - Subviews\
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageNameConstants.welcomeBG)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageNameConstants.welcomeLogo)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(type: .primary, text: String.stringFor(text: StringNameConstants.signin)) { [weak self] in
            self?.onLoginClick()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerButton: CustomButton = {
        let button = CustomButton(type: .secondary, text: String.stringFor(text: StringNameConstants.signup), onTap: {
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
        if Crashes.hasCrashedInLastSession {
            print ("App com falhas na ultima sessao")
        }
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
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -SizeConstants.smallMargin),

            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SizeConstants.mediumMargin)

        ])
    }
    
    // MARK: - Functions
    private func onLoginClick() {
        Analytics.trackEvent("Click", withProperties: ["Path": "welcome.login"])
        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }
    
    private func onRegisterClcik() {
        Analytics.trackEvent("Click", withProperties: ["Path": "welcome.register"])
        self.navigationController?.pushViewController(SignupVC(), animated: true)
    }

}
