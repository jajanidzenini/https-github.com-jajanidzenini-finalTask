//
//  User.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 18.01.24.
//

import Foundation

struct User: Codable {
    var id: Int
    var email: String
    var password: String
    var balance: Double
}

let randomUser = [
    User(id: 1 ,email: "user1", password: "123", balance: 4345.99),
    User(id:2 ,email: "user2", password: "111", balance: 654.99)
]
