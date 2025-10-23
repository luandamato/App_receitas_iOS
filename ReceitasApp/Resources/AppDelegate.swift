//
//  AppDelegate.swift
//  ReceitasApp
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        configureAppCenter()
        
        let token = UserDefaults.standard.string(forKey: "token")
        if token != nil {
            window?.rootViewController = UINavigationController(rootViewController: HomeVC())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: WelcomeVC())
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    private func configureAppCenter() {
        AppCenter.start(withAppSecret: "a885ce1d-d602-458f-9953-d098673525bf", services:[
          Analytics.self,
          Crashes.self
        ])
    }
    
    private func verifyTheme() {
        let darkOn = UserDefaults.standard.bool(forKey: "prefs_darkMode")
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if let ws = scene as? UIWindowScene {
                    for window in ws.windows {
                        window.overrideUserInterfaceStyle = darkOn ? .dark : .light
                    }
                }
            }
        } else {
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = darkOn ? .dark : .light
        }
    }

}

