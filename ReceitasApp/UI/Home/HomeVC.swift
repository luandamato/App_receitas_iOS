//
//  HomeVC.swift
//  ReceitasApp
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit

protocol HomeControllerProtocol: AnyObject {
    func reloadList(items: [Recipe])
    func addRecipes(items: [Recipe])
    func setLoading(visible: Bool, pagination: Bool)
    func showMessage(_ message: String)
    var hasMoreData: Bool { get set }
}

class HomeVC: BaseViewController {
    
    private var recipes: [Recipe] = []
    var viewModel: HomeViewModelProtocol
    var hasMoreData = true
    var isLoading = false
    
    private lazy var viewHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackViewHeader: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = SizeConstants.xSmallMargin
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNameConstants.icon)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblTitle: CustomLabel = {
        let view = CustomLabel(text: String.stringFor(text: StringNameConstants.home), type: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var btnSearch: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: ImageNameConstants.search), for: .normal)
        view.addTarget(self, action: #selector(toogleSearch), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txtSearch: CustomEditText = {
        let view = CustomEditText(placeholder: String.stringFor(text: StringNameConstants.search))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.type = .search
        view.isHidden = true
        view.searchDelegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = AppColor.primaryButton
        button.tintColor = .white
        button.setImage(UIImage(systemName: ImageNameConstants.plus), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: HomeViewModelProtocol = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.controller = self
    }

    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
        viewModel.getList()
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
        view.backgroundColor = AppColor.background
        viewHeader.addSubview(icon)
        viewHeader.addSubview(lblTitle)
        viewHeader.addSubview(btnSearch)
        stackViewHeader.addArrangedSubview(viewHeader)
        stackViewHeader.addArrangedSubview(txtSearch)
        view.addSubview(stackViewHeader)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: viewHeader.topAnchor),
            icon.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor),
            icon.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor),
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48),
            
            lblTitle.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: SizeConstants.xSmallMargin),
            
            btnSearch.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            btnSearch.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor),
            btnSearch.widthAnchor.constraint(equalToConstant: 30),
            btnSearch.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            stackViewHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            stackViewHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            
            tableView.topAnchor.constraint(equalTo: stackViewHeader.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.smallMargin),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SizeConstants.xSmallMargin)
        ])
        
    }
    
    @objc func toogleSearch() {
        UIView.animate(withDuration: 0.3, animations: {
            self.txtSearch.isHidden = !self.txtSearch.isHidden
        })
    }
    
    @objc private func addButtonTapped() {
        let vc = SwiftUiVC(swiftUIView: AddRecipeView())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        cell.configure(with: recipes[indexPath.row])
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SwiftUiVC(swiftUIView: RefeicaoView(refeicao: recipes[indexPath.row]))
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Quando chegar nos últimos 5 itens, tenta carregar mais
        if indexPath.row == recipes.count - 1 && !isLoading && hasMoreData {
            viewModel.getNextPage()
        }
    }
}

extension HomeVC: SearchDelegate {
    func searchRemote(value: String) {
        
    }
    func searchLocal(value: String) {
        
    }
}

extension HomeVC: HomeControllerProtocol {
    func reloadList(items: [Recipe]) {
        self.recipes = items
        self.tableView.reloadData()
    }
    
    func addRecipes(items: [Recipe]) {
        self.recipes.append(contentsOf: items)
        self.tableView.reloadData()
    }

    func setLoading(visible: Bool, pagination: Bool) {
        if pagination {
            isLoading = visible
        }
        self.setLoading(visible: visible, fullScreen: !pagination)
    }

    func showMessage(_ message: String) {
        showToast(message: message)
    }
}
