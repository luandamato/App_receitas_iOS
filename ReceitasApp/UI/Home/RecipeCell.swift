//
//  RecipeCell.swift
//  Recipes
//
//  Created by Luan Damato on 22/10/25.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    static let identifier = "RecipeTableViewCell"
    
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = false
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: CustomLabel = {
        let lbl = CustomLabel(type: .title)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = CustomLabel(type: .body)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = AppColor.divider
        contentView.backgroundColor = AppColor.background
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SizeConstants.mediumMargin)
        ])
        
        containerView.addSubview(recipeImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: SizeConstants.smallMargin),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SizeConstants.smallMargin),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SizeConstants.smallMargin),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SizeConstants.xSmallMargin),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SizeConstants.smallMargin)
        ])
    }
    
    func configure(with recipe: Recipe) {
        recipeImageView.setImage(from: recipe.images?.first)
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.description
    }
}
