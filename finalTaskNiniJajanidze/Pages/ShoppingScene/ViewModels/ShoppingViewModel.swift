//  ShoppingViewModel.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 16.01.24.

import Foundation
import Alamofire

// MARK: - Delegates
protocol ProductListViewModelTypeDelegate {
    var input: ProductListViewModelInputDelegate { get }
    var output: ProductListViewModelOutputDelegate? { get set }
}

protocol ProductListViewModelInputDelegate {
    func getProduct()
}

protocol ProductListViewModelOutputDelegate {
    func reloadData()
    func showError(text: String)
}

class ShoppingViewModel: ProductListViewModelTypeDelegate {
    
    var input: ProductListViewModelInputDelegate { self }
    var output: ProductListViewModelOutputDelegate?
    
    private var products: [Product] = []
    private var userCart: [CartItem] = []
    private var currentUser: User!
    
    private var totalItemCount: Int = 0
    private var totalPrice: Double = 0.0
    
    init() {
        setCurrentUser()
        getUserCart()
        getItemCountAndPrice ()
    }
    
    private func getUserCart() {
        userCart = CartManager.shared.getCart(forUser: currentUser.id)
    }
    
    func isCartEmpty() -> Bool {
        return userCart.isEmpty
    }
    
    func addToCart(product: Product) {
        if product.stock > 0 {
            if let index = userCart.firstIndex(where: { $0.product.id == product.id }) {
                userCart[index].quantity += 1
            } else {
                userCart.append(CartItem(product: product, quantity: 1))
            }
            adjustStock(ofProductWithId: product.id, by: -1)
            updateCartAndBalance()
        } else {
            output?.showError(text: "Product is out of stock.")
        }
    }
    
    func removeFromCart(product: Product) {
        if let cartIndex = userCart.firstIndex(where: { $0.product.id == product.id }) {
            if userCart[cartIndex].quantity > 1 {
                userCart[cartIndex].quantity -= 1
                adjustStock(ofProductWithId: product.id, by: 1)
            } else {
                userCart.remove(at: cartIndex)
                adjustStock(ofProductWithId: product.id, by: 1)
            }
            updateCartAndBalance()
        } else {
            output?.showError(text: "No product found in the cart.")
        }
    }
    
    private func adjustStock(ofProductWithId productId: Int, by amount: Int) {
        if let index = products.firstIndex(where: { $0.id == productId }) {
            products[index].stock += amount
        }
    }
    
    private func updateCartAndBalance() {
        CartManager.shared.saveCart(userCart, forUser: currentUser.id)
        getItemCountAndPrice ()
        output?.reloadData()
    }
    
    private func getItemCountAndPrice() {
        totalItemCount = userCart.reduce(0) { $0 + $1.quantity }
        totalPrice = userCart.reduce(0.0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    func getQuantity(for product: Product) -> Int {
        if let cartItem = userCart.first(where: { $0.product.id == product.id }) {
            return cartItem.quantity
        } else {
            return 0
        }
    }
    
    func getTotalItemCount() -> Int {
        return totalItemCount
    }
    
    func getTotalPrice() -> Double {
        return totalPrice
    }
    
    private func setCurrentUser() {
        self.currentUser = UserDefaultsManager.shared.getUser()
    }
    
    func getItemsForSecondViewModel() -> [CartItem] {
        return userCart
    }
    
    var categorizedProducts: [(category: String, products: [Product])] {
        let groupedProducts = Dictionary(grouping: products, by: { $0.category })
        return groupedProducts.map { (category: $0.key, products: $0.value) }.sorted { $0.category < $1.category }
    }
    
    private func fetchProduct() {
        let urlString = "https://dummyjson.com/products"
        NetworkService.shared.getData(from: urlString) { [weak self] (result: Result<ProductResponse, NetworkServiceError>) in
            switch result {
            case .success(let productResponse):
                self?.products = productResponse.products
                self?.output?.reloadData()
            case .failure(let error):
                self?.output?.showError(text: error.localizedDescription)
            }
        }
    }
    
}

extension ShoppingViewModel: ProductListViewModelInputDelegate {
    func getProduct() {
        fetchProduct()
    }
}
