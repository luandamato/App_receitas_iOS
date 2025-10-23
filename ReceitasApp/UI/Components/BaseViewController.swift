//
//  BaseViewController.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//
import UIKit

class BaseViewController: UIViewController {
    let contentView = UIView()
    private let loadView = CustomLoader()
    private var contentViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        self.view.backgroundColor = AppColor.background
        closeKeyboardOnTouch()
        configureLoadView()
        super.viewDidLoad()
        configureContentView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.backgroundColor = AppColor.background

        contentViewTopConstraint = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            contentViewTopConstraint,
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Loading
extension BaseViewController {
    private func configureLoadView() {
        loadView.translatesAutoresizingMaskIntoConstraints = false
        loadView.tag = 12321
        loadView.setFullScreen(true)
        self.view.addSubview(loadView)
        NSLayoutConstraint.activate([
            loadView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            loadView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            loadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.loadView.alpha = 0
    }

    func setLoading(visible: Bool, fullScreen: Bool = true){
        self.view.bringSubviewToFront(loadView)
        if !visible{
            UIView.animate(withDuration: 0.5) {
                self.loadView.alpha = 0
            }
            return
        }
        loadView.setFullScreen(fullScreen)
        loadView.animate()
        loadView.alpha = 1.0
    }
}

// MARK: - NavBar
extension BaseViewController {
    func addBackButton(title: String = "", action: (() -> Void)? = nil) {
        let topBar = UIView()
        let backButton = UIButton(type: .system)
        let titleLabel = UILabel()

        topBar.backgroundColor = AppColor.background
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 56),
        ])
        contentViewTopConstraint.isActive = false
        contentViewTopConstraint = contentView.topAnchor.constraint(equalTo: topBar.bottomAnchor)
        contentViewTopConstraint.isActive = true
        self.view.layoutIfNeeded()

        // Back button
        let backImage = UIImage(named: ImageNameConstants.back)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = AppColor.title
        if let action {
            backButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
        }else {
            backButton.addTarget(self, action: #selector(voltar), for: .touchUpInside)
        }
        topBar.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        // Title label
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = AppColor.title
        topBar.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
    }

    @objc func voltar() {
        navigationController?.popViewController(animated: true)
    }
}
