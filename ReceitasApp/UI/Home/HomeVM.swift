//
//  HomeVM.swift
//  Recipes
//
//  Created by Luan Damato on 30/10/25.
//

import Foundation

protocol HomeViewModelProtocol {
    var controller: HomeControllerProtocol? { get set }
    func getList()
    func getNextPage()
    func filterRecipes(searchText: String)
    func filterOnline(searchText: String)
}

class HomeViewModel: HomeViewModelProtocol {
    weak var controller: HomeControllerProtocol?
    var currentPage = 0

    private(set) var emailError: String?
    private(set) var passwordError: String?
    private(set) var genericError: String?
    private var recipes: [Recipe] = []
    private var searchValue = ""

    func getList() {
        currentPage = 0
        self.controller?.setLoading(visible: true, pagination: false)
        APIClient.shared.request(
            endPoint: .getRecipes(page: 0),
            onSuccess: { (recipes: [Recipe]) in
                self.recipes = recipes
                self.controller?.setLoading(visible: false, pagination: false)
                self.controller?.reloadList(items: recipes)
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false, pagination: false)
                self.controller?.showMessage(errorMessage)
            }
        )
    }

    func getNextPage() {
        currentPage += 1
        self.controller?.setLoading(visible: true, pagination: true)
        APIClient.shared.request(
            endPoint: .filterRecipes(page: currentPage, filter: searchValue),
            onSuccess: { (recipes: [Recipe]) in
                if recipes.isEmpty {
                    self.controller?.hasMoreData = false
                }
                self.recipes.append(contentsOf: recipes)
                self.controller?.setLoading(visible: false, pagination: true)
                self.controller?.addRecipes(items: recipes)
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false, pagination: true)
                self.controller?.showMessage(errorMessage)
            }
        )
    }
    
    func filterRecipes(searchText: String) {
        self.searchValue = searchText
        guard !searchText.isEmpty else {
            self.controller?.reloadList(items: self.recipes)
            return
        }
        let lowercasedSearch = searchText.lowercased()
        let filtered = recipes.filter { recipe in
            let nameMatch = recipe.name.lowercased().contains(lowercasedSearch)
            let ownerMatch = recipe.owner?.lowercased().contains(lowercasedSearch) ?? false
            return nameMatch || ownerMatch
        }
        self.controller?.reloadList(items: filtered)
    }

    func filterOnline(searchText: String) {
        currentPage = 0
        self.controller?.setLoading(visible: true, pagination: false)
        APIClient.shared.request(
            endPoint: .filterRecipes(page: currentPage, filter: searchText),
            onSuccess: { (recipes: [Recipe]) in
                self.recipes = recipes
                self.controller?.setLoading(visible: false, pagination: false)
                self.controller?.reloadList(items: recipes)
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false, pagination: false)
                self.controller?.showMessage(errorMessage)
            }
        )
    }
}
