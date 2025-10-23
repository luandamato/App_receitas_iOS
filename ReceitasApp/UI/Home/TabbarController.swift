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
        setupTabBarAppearance()
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
        selectedIndex = 1
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = AppColor.background.withAlphaComponent(0.8)
        
        appearance.backgroundEffect = nil
        
        tabBar.tintColor = AppColor.primaryButton
        tabBar.unselectedItemTintColor = .lightGray
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
    }
}
