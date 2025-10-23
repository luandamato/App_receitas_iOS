//
//  ProfileVC.swift
//  ReceitasApp
//
//  Created by Luan Damato on 23/10/25.
//

import UIKit

class ProfileVC: BaseViewController {
    
    // MARK: - Mock data (depois você pode carregar do user real)
    private let userImage = UIImage(named: ImageNameConstants.profile)
    private let userName = "Luan Damato"
    private let userEmail = "luan@email.com"
    private let userBio = "Amante de culinária e tecnologia. Adoro criar receitas e aprender novas técnicas na cozinha."
    private let userSince = "Outubro de 2023"
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 60
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let lblName: CustomLabel = {
        let label = CustomLabel(type: .title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblEmail: CustomLabel = {
        let label = CustomLabel(type: .body)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblBioTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = String.stringFor(text: .bio)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblBio: CustomLabel = {
        let label = CustomLabel(type: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblSinceTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = String.stringFor(text: .sinceAt)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblSince: CustomLabel = {
        let label = CustomLabel(type: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = SizeConstants.mediumMargin
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUser()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        
        [userImageView, lblName, lblEmail, lblBioTitle, lblBio, lblSinceTitle, lblSince, buttonsStack].forEach {
            contentContainer.addSubview($0)
        }
        
        setupButtons()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            userImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 30),
            userImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 120),
            userImageView.heightAnchor.constraint(equalToConstant: 120),
            
            lblName.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 12),
            lblName.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            lblEmail.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 4),
            lblEmail.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            lblBioTitle.topAnchor.constraint(equalTo: lblEmail.bottomAnchor, constant: 25),
            lblBioTitle.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            
            lblBio.topAnchor.constraint(equalTo: lblBioTitle.bottomAnchor, constant: 4),
            lblBio.leadingAnchor.constraint(equalTo: lblBioTitle.leadingAnchor),
            lblBio.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            
            lblSinceTitle.topAnchor.constraint(equalTo: lblBio.bottomAnchor, constant: 20),
            lblSinceTitle.leadingAnchor.constraint(equalTo: lblBioTitle.leadingAnchor),
            
            lblSince.topAnchor.constraint(equalTo: lblSinceTitle.bottomAnchor, constant: 4),
            lblSince.leadingAnchor.constraint(equalTo: lblBioTitle.leadingAnchor),
            
            buttonsStack.topAnchor.constraint(equalTo: lblSince.bottomAnchor, constant: 30),
            buttonsStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            buttonsStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            buttonsStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupButtons() {
        let buttons: [(String, String, UIColor?, Selector)] = [
            (String.stringFor(text: .editProfile), "pencil", nil, #selector(editProfile)),
            (String.stringFor(text: .preferences), "slider.horizontal.3", nil, #selector(openPreferences)),
            (String.stringFor(text: .myRecipes), "book", nil, #selector(openMyRecipes)),
            (String.stringFor(text: .changePassword), "key", nil, #selector(changePassword)),
            (String.stringFor(text: .exit), "arrow.right.circle.fill", AppColor.error, #selector(logout))
        ]
        
        buttons.forEach { title, systemIcon, color, selector in
            let button = createButton(title: title, icon: systemIcon, tintColor: color ?? AppColor.primaryButton)
            let tap = UITapGestureRecognizer(target: self, action: selector)
            button.addGestureRecognizer(tap)
            buttonsStack.addArrangedSubview(button)
        }
    }
    
    private func createButton(title: String, icon: String, tintColor: UIColor) -> UIView {
        let view = UIView()
        let image = UIImageView()
        let text = CustomLabel(text: title, type: .body)
        let divider = UIView()
        
        image.image = UIImage(systemName: icon)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.tintColor = tintColor
        image.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = AppColor.divider
        
        view.addSubview(image)
        view.addSubview(text)
        view.addSubview(divider)
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 25),
            image.widthAnchor.constraint(equalToConstant: 25),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            text.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            text.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: SizeConstants.xSmallMargin),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: image.bottomAnchor, constant: SizeConstants.smallMargin),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - Configure
    
    private func configureUser() {
        userImageView.image = userImage
        lblName.text = userName
        lblEmail.text = userEmail
        lblBio.text = userBio
        lblSince.text = userSince
    }
    
    // MARK: - Actions
    
    @objc private func editProfile() {
        print("Editar perfil")
    }
    
    @objc private func openPreferences() {
        print("Abrir preferências")
    }
    
    @objc private func openMyRecipes() {
        print("Abrir minhas receitas")
    }
    
    @objc private func changePassword() {
        print("Trocar senha")
    }
    
    @objc private func logout() {
        print("Sair da conta")
    }
}
