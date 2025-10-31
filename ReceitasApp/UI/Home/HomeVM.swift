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
}

class HomeViewModel: HomeViewModelProtocol {
    weak var controller: HomeControllerProtocol?
    var currentPage = 0

    private(set) var emailError: String?
    private(set) var passwordError: String?
    private(set) var genericError: String?

    func getList() {
        self.controller?.setLoading(visible: true, pagination: false)
        APIClient.shared.request(
            endPoint: .getRecipes(page: 0),
            onSuccess: { (recipes: [Recipe]) in
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
            endPoint: .getRecipes(page: currentPage),
            onSuccess: { (recipes: [Recipe]) in
                if recipes.isEmpty {
                    self.controller?.hasMoreData = false
                }
                self.controller?.setLoading(visible: false, pagination: true)
                self.controller?.addRecipes(items: recipes)
            },
            onError: { errorMessage, statusCode in
                self.controller?.setLoading(visible: false, pagination: true)
                self.controller?.showMessage(errorMessage)
            }
        )
    }
}
