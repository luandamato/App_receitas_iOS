//
//  WelcomeVC.swift
//  ReceitasApp
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit

class WelcomeVC: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("welcome", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = AppColor.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = AppColor.background
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            // Título centralizado na tela
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
