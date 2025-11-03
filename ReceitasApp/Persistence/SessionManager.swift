//
//  SessionManager.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    private let userKey = "loggedUser"

    private init() {}

    func saveUser(_ user: AuthResponse) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }

    func getUser() -> AuthResponse? {
        if let data = UserDefaults.standard.data(forKey: userKey) {
            return try? JSONDecoder().decode(AuthResponse.self, from: data)
        }
        return nil
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    func update(user: User) {
        guard var savedUser = getUser() else { return }
        savedUser.user = user
        saveUser(savedUser)
    }
}
