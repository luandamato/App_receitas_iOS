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
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // nome igual ao .xcdatamodeld
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        configureAppCenter()
        loadScreen()
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

    private func loadScreen() {
        window?.rootViewController = UINavigationController(rootViewController: WelcomeVC())
        guard let user = UserSessionManager.shared.getUser() else {
            return
        }
        let body = refreshTokenRequest(refresh_token: user.refreshToken)
        APIClient.shared.request(
            endPoint: .refreshToken,
            method: .post,
            body: body,
            onSuccess: { (userResponse: AuthResponse) in
                UserSessionManager.shared.saveUser(userResponse)
                
                let home = MainTabBarController()
                home.modalPresentationStyle = .fullScreen
                self.window?.rootViewController = home
            },
            onError: { errorMessage, statusCode in
                UIApplication.shared.getTopViewController?.showToast(message: errorMessage)
                UserSessionManager.shared.clearUser()
            }
        )
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
