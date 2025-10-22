//
//  LoginVC.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//
import UIKit

class LoginVC: BaseViewController {

    let cameFromRegister: Bool
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
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.welcome), type: .title)
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
        view.addTarget(self, action: #selector(onRegisterClcik), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializer
    init(cameFromRegister: Bool = false) {
        self.cameFromRegister = cameFromRegister
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.cameFromRegister = true
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
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor) ,// importante para rolar só verticalmente!
            contentContainer.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor)
        ])

        // Adiciona subviews no container
        [lblTitle, txtEmail, txtPassword, loginButton, forgotPasswordBtn, registerButton].forEach { contentContainer.addSubview($0) }

        // Layout manual dos elementos (ajuste margens conforme necessário)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            lblTitle.heightAnchor.constraint(equalToConstant: 40),

            txtEmail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.bigMargin),
            txtEmail.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtEmail.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: SizeConstants.smallMargin),
            txtPassword.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtPassword.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            loginButton.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: SizeConstants.bigMargin),
            loginButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            loginButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            forgotPasswordBtn.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: SizeConstants.smallMargin),
            forgotPasswordBtn.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            forgotPasswordBtn.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            // O botão de registro fica sempre no final do conteúdo!
            registerButton.topAnchor.constraint(greaterThanOrEqualTo: forgotPasswordBtn.bottomAnchor, constant: 0),
            registerButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            registerButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            registerButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -SizeConstants.mediumMargin)
        ])
    }

    // MARK: - Actions

    private func onLoginClick() {
        let home = MainTabBarController()
        home.modalPresentationStyle = .fullScreen
        self.navigationController?.present(home, animated: false)
    }

    @objc private func onRegisterClcik() {
        if cameFromRegister {
            navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.pushViewController(SignupVC(cameFromLogin: true), animated: true)
        }
    }

    @objc private func onForgotPasswordClick() {
        let vc = ForgotPasswordVC(email: txtEmail.getTexto())
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
