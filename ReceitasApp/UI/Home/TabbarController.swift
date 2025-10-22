//
//  TabbarController.swift
//  Recipes
//
//  Created by Luan Damato on 22/10/25.
//
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let favoritesVC = UINavigationController(rootViewController: FavoritesVC())
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         selectedImage: UIImage(systemName: "house.fill"))
        
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites",
                                              image: UIImage(systemName: "heart"),
                                              selectedImage: UIImage(systemName: "heart.fill"))
        
        profileVC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person"),
                                            selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [favoritesVC, homeVC, profileVC]
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .systemOrange      // ícone + texto selecionado
        tabBar.unselectedItemTintColor = .systemGray // ícones deselecionados
        tabBar.backgroundColor = .systemBackground
    }
}
