//
//  LoginController.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 15.01.24.
//
import Foundation

enum LoginError: Error {
    case allFieldsRequired
    case invalidEmailFormat
    case passwordTooShort
    case incorrectCredentials
}

protocol UserViewModelDelegate: AnyObject {
    func loginDidSucceed(user: User)
    func loginDidFail(withError error: LoginError)
}

protocol UserViewModelProtocol {
    func loginUser(email: String, password: String)
}

class UserViewModel: UserViewModelProtocol {

    weak var delegate: UserViewModelDelegate?

    func loginUser(email: String, password: String) {
    
        guard !email.isEmpty, !password.isEmpty else {
            delegate?.loginDidFail(withError: .allFieldsRequired)
            return
        }

        if let user = randomUser.first(where: { $0.email == email && $0.password == password }) {
            delegate?.loginDidSucceed(user: user)
        } else {
            delegate?.loginDidFail(withError: .incorrectCredentials)
        }
    }
}


    // MARK: - Save User & logged status
    func saveUserToUserDefaults(_ user: User) {
        UserDefaultsManager.shared.saveUser(user)
        UserDefaultsManager.shared.setLoginStatus(true)
    }

