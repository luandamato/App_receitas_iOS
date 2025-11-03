//
//  AboutUserVC.swift
//  Recipes
//
//  Created by Luan Damato on 21/10/25.
//
import UIKit

protocol AboutUserControllerProtocol: AnyObject {
    func gotoHome()
    func updateErros()
    func setLoading(visible: Bool)
}
class AboutUserVC: BaseViewController {

    let cameFromRegister: Bool
    var viewModel: AboutUserViewModelProtocol
    var userImage: UIImage?
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
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.configureProfile), type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lblSubTitle: CustomLabel = {
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.configureProfileDescription), type: .body)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imgUser: UserPhotoPickerView = {
        let view = UserPhotoPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var txtUserName: CustomEditText = {
        let view = CustomEditText(titulo: String.stringFor(text: StringNameConstants.username),
                                  placeholder: String.stringFor(text: StringNameConstants.usernameHint))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtBio: CustomTextArea = {
        let view = CustomTextArea(titulo: String.stringFor(text: StringNameConstants.bio))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.limiteCaracteres = 500
        return view
    }()

    private lazy var btnUpdate: CustomButton = {
        let button = CustomButton(type: .primary, text: String.stringFor(text: StringNameConstants.update)) { [weak self] in
            self?.onUpdateClick()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    init(cameFromRegister: Bool = false, viewModel: AboutUserViewModelProtocol = AboutUserViewModel()) {
        self.cameFromRegister = cameFromRegister
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.controller = self
    }

    required init?(coder: NSCoder) {
        self.cameFromRegister = true
        self.viewModel = AboutUserViewModel()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(action: voltar)
        setupViews()
        self.setupKeyboardHandling(scrollView)
        fillFields()
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
        [lblTitle, lblSubTitle, imgUser, txtUserName, txtBio, btnUpdate].forEach { contentContainer.addSubview($0) }

        // Layout manual dos elementos (ajuste margens conforme necessário)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            lblSubTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.smallMargin),
            lblSubTitle.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            lblSubTitle.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            imgUser.topAnchor.constraint(equalTo: lblSubTitle.bottomAnchor, constant: SizeConstants.mediumMargin),
            imgUser.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            imgUser.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),

            txtUserName.topAnchor.constraint(equalTo: imgUser.bottomAnchor, constant: SizeConstants.smallMargin),
            txtUserName.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtUserName.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            txtBio.topAnchor.constraint(equalTo: txtUserName.bottomAnchor, constant: SizeConstants.smallMargin),
            txtBio.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            txtBio.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            btnUpdate.topAnchor.constraint(greaterThanOrEqualTo: txtUserName.bottomAnchor, constant: 0),
            btnUpdate.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: SizeConstants.mediumMargin),
            btnUpdate.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -SizeConstants.mediumMargin),
            btnUpdate.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -SizeConstants.mediumMargin)
        ])
    }
    
    private func fillFields() {
        guard let user = UserSessionManager.shared.getUser()?.user else {
            return
        }
        imgUser.setImageFor(link: UserSessionManager.shared.getUser()?.user.userMetadata.avatarUrl)
        txtUserName.set(texto: user.userMetadata.username)
        txtBio.set(texto: user.userMetadata.bio)
    }

    // MARK: - Actions

    private func onUpdateClick() {
        viewModel.update(username: txtUserName.getTexto(),
                         bio: txtBio.getTexto(),
                         photo: self.userImage)
    }
    
    @objc private func close() {
        if cameFromRegister{
            let home = MainTabBarController()
            home.modalPresentationStyle = .fullScreen
            self.navigationController?.present(home, animated: false)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AboutUserVC: UserPhotoPickerViewDelegate {
    func userPhotoPickerView(_ picker: UserPhotoPickerView, didSelect image: UIImage) {
        self.userImage = image
    }
}

extension AboutUserVC: AboutUserControllerProtocol {
    func gotoHome() {
        close()
    }
    
    func updateErros() {
        txtBio.setError(viewModel.bioError)
        txtUserName.setError(viewModel.usernameError)
        showToast(message: viewModel.genericError)
    }
    
    func setLoading(visible: Bool) {
        btnUpdate.setLoading(visible: visible)
    }
}
