//
//  UserDefaultsManager.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 21.01.24.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let currentUserKey = "currentUser"
    private let isLoggedInKey = "isUserLoggedIn"
    
    private init() {}
    
    func saveUser(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: currentUserKey)
        }
    }
    
    func getUser() -> User? {
        if let userData = UserDefaults.standard.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }
    
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    func clearUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func setLoginStatus(_ isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
    }
}
