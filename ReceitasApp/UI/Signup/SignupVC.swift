//
//  SignupVC.swift
//  Recipes
//
//  Created by Luan Damato on 19/10/25.
//

import UIKit

class SignupVC: BaseViewController {

    let cameFromLogin: Bool
    // MARK: - Subviews

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()

    private lazy var contentContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var lblTitle: CustomLabel = {
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.createAccount), type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var txtName: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.fullName),
                                  placeholder: String.stringFor(text: StringNameConstants.fullNameHint))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtEmail: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.email),
                                  placeholder: String.stringFor(text: StringNameConstants.fillEmail))
        view.tipoTeclado = .emailAddress
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtBirthdate: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.birthDate),
                                  placeholder: String.stringFor(text: StringNameConstants.birthDateHint))
        view.tipoTeclado = .decimalPad
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var txtPassword: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.createPassword),
                                  placeholder: String.stringFor(text: StringNameConstants.fillPassword))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.senha = true
        return view
    }()
    
    private lazy var txtConfirmPassword: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.confirmPassword),
                                  placeholder: String.stringFor(text: StringNameConstants.fillPassword))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.senha = true
        return view
    }()

    private lazy var signupButton: CustomButton = {
        let button = CustomButton(type: .primary, text: String.stringFor(text: StringNameConstants.register)) { [weak self] in
            self?.onSignUpClick()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButton: UIButton = {
        let view = UIButton(type: .system)
        let normalText = String.stringFor(text: StringNameConstants.alredyRegistered)
        let underlinedText = String.stringFor(text: StringNameConstants.signin)
        let normalAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : AppColor.body,
            .font : UIFont.systemFont(ofSize: 12)
        ]
        let underlinedAttributes : [NSAttributedString.Key : Any] = [
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .foregroundColor : AppColor.primaryButton,
            .font : UIFont.systemFont(ofSize: 12)
        ]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttributes)
        let underlinedAttributedString = NSAttributedString(string: underlinedText, attributes: underlinedAttributes)
        attributedString.append(underlinedAttributedString)
        view.setAttributedTitle(attributedString, for: .normal)
        view.backgroundColor = .clear
        view.titleLabel?.textAlignment = .center
        view.addTarget(self, action: #selector(onLoginClick), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializer
    init(cameFromLogin: Bool = false) {
        self.cameFromLogin = cameFromLogin
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.cameFromLogin = true
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupViews()
        self.setupKeyboardHandling(scrollView)
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        // ScrollView constraints (preenche contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])

        // ContentContainer (dentro do scroll, para facilitar layout vertical)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Adiciona subviews no container
        [lblTitle, txtName, txtEmail, txtBirthdate, txtPassword, txtConfirmPassword, signupButton, loginButton].forEach { contentContainer.addSubview($0) }

        // Layout manual dos elementos (ajuste margens conforme necessário)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            lblTitle.heightAnchor.constraint(equalToConstant: 40),

            txtName.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.smallMargin),
            txtName.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtName.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            txtEmail.topAnchor.constraint(equalTo: txtName.bottomAnchor, constant: SizeConstants.smallMargin),
            txtEmail.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtEmail.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            txtBirthdate.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: SizeConstants.smallMargin),
            txtBirthdate.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtBirthdate.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            txtPassword.topAnchor.constraint(equalTo: txtBirthdate.bottomAnchor, constant: SizeConstants.smallMargin),
            txtPassword.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtPassword.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            txtConfirmPassword.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: SizeConstants.smallMargin),
            txtConfirmPassword.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtConfirmPassword.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            signupButton.topAnchor.constraint(equalTo: txtConfirmPassword.bottomAnchor, constant: SizeConstants.bigMargin),
            signupButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            signupButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            loginButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: SizeConstants.smallMargin),
            loginButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            loginButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            loginButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -SizeConstants.mediumMargin)
        ])
    }

    // MARK: - Actions

    @objc private func onLoginClick() {
        if cameFromLogin {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.pushViewController(LoginVC(cameFromRegister: true), animated: true)
        }
    }

    @objc private func onSignUpClick() {
        
    }
}
