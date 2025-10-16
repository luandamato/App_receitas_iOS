//
//  AppDelegate.swift
//  ReceitasApp
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let token = UserDefaults.standard.string(forKey: "token")
        if token != nil {
            window?.rootViewController = HomeVC()
        } else {
            window?.rootViewController = WelcomeVC()
        }
        
        window?.makeKeyAndVisible()
        return true
    }

}

