//
//  FavoritesVC.swift
//  Recipes
//
//  Created by Luan Damato on 22/10/25.
//

import UIKit

class FavoritesVC: BaseViewController {
    
    private var recipes: [Recipe] = []
    
    private let lblTitle: CustomLabel = {
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.favorites), type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recipes = RecipeCoreDataManager.shared.getAll()
        print("\(recipes.count)")
        print(recipes.first?.name)
        print(recipes.first?.id)
        print(((recipes.first?.images) as? [String])?.first)
        
        RecipeCoreDataManager.shared.delete(recipe: recipes.first!)
        print("\(recipes.count)")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
    }
    
    private func setupLayout() {
        view.addSubview(lblTitle)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SizeConstants.mediumMargin),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: SizeConstants.smallMargin),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        cell.configure(with: recipes[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

