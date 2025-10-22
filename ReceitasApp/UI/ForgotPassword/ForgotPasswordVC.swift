//
//  ForgotPasswordVC.swift
//  Recipes
//
//  Created by Luan Damato on 17/10/25.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    
    // MARK: - Subviews\
    private lazy var lblTitle: CustomLabel = {
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.recoveryPassword), type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lblDescription: CustomLabel = {
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.recoveryPasswordDescription), type: .body)
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
    
    private lazy var sendEmailButton: CustomButton = {
        let button = CustomButton(type: .primary, text: String.stringFor(text: StringNameConstants.recoveryPasswordButton)) { [weak self] in
            self?.onSendEmailClick()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.txtEmail.set(texto: email)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(lblTitle)
        view.addSubview(lblDescription)
        view.addSubview(txtEmail)
        view.addSubview(sendEmailButton)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SizeConstants.smallMargin),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            lblTitle.heightAnchor.constraint(equalToConstant: 40),
            
            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.smallMargin),
            lblDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            txtEmail.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: SizeConstants.bigMargin),
            txtEmail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtEmail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            sendEmailButton.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: SizeConstants.mediumMargin),
            sendEmailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            sendEmailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
        ])
    }
    
    private func onSendEmailClick() {
        showToast(message: "Email enviado")
        self.navigationController?.popViewController(animated: true)
    }
}
