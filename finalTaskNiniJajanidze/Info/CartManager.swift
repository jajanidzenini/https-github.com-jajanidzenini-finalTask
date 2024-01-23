//
//  CartManager.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 21.01.24.
//

import Foundation

class CartManager {
   
    static let shared = CartManager()
    
    private init() {}
    
    private let cartKeyPrefix = "cart_"
    
    func getCart(forUser userId: Int) -> [CartItem] {
        guard let cartData = UserDefaults.standard.data(forKey: "\(cartKeyPrefix)\(userId)"),
              let cartItems = try? JSONDecoder().decode([CartItem].self, from: cartData) else {
            return []
        }
        return cartItems
    }
    
    func saveCart(_ cart: [CartItem], forUser userId: Int) {
        if let encodedData = try? JSONEncoder().encode(cart) {
            UserDefaults.standard.set(encodedData, forKey: "\(cartKeyPrefix)\(userId)")
        }
    }
    
    func addToCart(product: Product, forUser userId: Int) {
        var cart = getCart(forUser: userId)
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartItem(product: product, quantity: 1))
        }
        saveCart(cart, forUser: userId)
    }
    
    func removeFromCart(product: Product, forUser userId: Int) {
        var cart = getCart(forUser: userId)
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[index].quantity = max(1, cart[index].quantity - 1)
            if cart[index].quantity == 1 {
                cart.remove(at: index)
            }
        }
        saveCart(cart, forUser: userId)
    }
    
    func clearCart(forUser userId: Int) {
        UserDefaults.standard.removeObject(forKey: "\(cartKeyPrefix)\(userId)")
    }
    
    func isCartEmpty(forUser userId: Int) -> Bool {
        return getCart(forUser: userId).isEmpty
    }
}
