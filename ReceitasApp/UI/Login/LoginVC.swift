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
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.welcome), type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtEmail: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.email),
                                  placeholder: String.stringFor(text: StringNameConstants.fillEmail))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtPassword: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.password),
                                  placeholder: String.stringFor(text: StringNameConstants.fillPassword))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.senha = true
        return view
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(type: .primary, text: String.stringFor(text: StringNameConstants.signin)) { [weak self] in
            self?.onLoginClick()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordBtn: UIButton = {
        let view = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: String.stringFor(text: StringNameConstants.forgotPassword),
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: AppColor.primaryButton,
                .font: UIFont.systemFont(ofSize: 12)
            ]
        )
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .clear
        view.titleLabel?.textAlignment = .center
        view.addTarget(self, action: #selector(onForgotPasswordClick), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let view = UIButton(type: .system)
        
        let normalText = String.stringFor(text: StringNameConstants.noAccount)
        let underlinedText = String.stringFor(text: StringNameConstants.loginSignup)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.body,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        let underlinedAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: AppColor.primaryButton,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttributes)
        let underlinedAttributedString = NSAttributedString(string: underlinedText, attributes: underlinedAttributes)
        attributedString.append(underlinedAttributedString)
        view.setAttributedTitle(attributedString, for: .normal)
        
        view.backgroundColor = .clear
        view.titleLabel?.textAlignment = .center
        view.addTarget(self, action: #selector(onRegisterClcik), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(lblTitle)
        view.addSubview(txtEmail)
        view.addSubview(txtPassword)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordBtn)
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SizeConstants.smallMargin),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            lblTitle.heightAnchor.constraint(equalToConstant: 40),
            
            txtEmail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.bigMargin),
            txtEmail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtEmail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
        
            txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: SizeConstants.smallMargin),
            txtPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            loginButton.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: SizeConstants.bigMargin),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            forgotPasswordBtn.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: SizeConstants.smallMargin),
            forgotPasswordBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            forgotPasswordBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),

            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SizeConstants.mediumMargin)

        ])
    }
    
    private func onLoginClick() {
        loginButton.setLoading(visible: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loginButton.setLoading(visible: false)
        }
    }
    
    @objc private func onRegisterClcik() {
        setLoading(visible: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.setLoading(visible: false)
        }
    }
    
    @objc private func onForgotPasswordClick() {
        print("Botão sublinhado clicado!")
    }

}
