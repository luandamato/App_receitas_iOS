//
//  BaseViewController.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation
import UIKit

class BaseViewController: UIViewController{
    
    let contentView = UIView()
    let loadView = CustomLoader()
    
    override func viewDidLoad() {
        self.view.backgroundColor = AppColor.background
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
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    func addBackButton(title: String = "") {
        let topBar = UIView()
        let backButton = UIButton(type: .system)
        let titleLabel = UILabel()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        contentView.backgroundColor = AppColor.background
        topBar.backgroundColor = AppColor.background
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 56),
            
            contentView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Back button
        let backImage = UIImage(named: ImageNameConstants.back)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = AppColor.title
        backButton.addTarget(self, action: #selector(voltar), for: .touchUpInside)
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
