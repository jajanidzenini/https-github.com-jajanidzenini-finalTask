//
//  ShoppingViewController.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 17.01.24.
//

import UIKit

class ShoppingViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        if let iconImage = UIImage(named: "logout") {
            button.setImage(iconImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 68/255.0, green: 165/255.0, blue: 255/255.0, alpha: 1.0)
        return view
    }()
    
    private lazy var transparentButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bag")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var lineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Line")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var totalItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "0 x"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 $"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.text = "go_to_cart"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow-right")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var viewModel = ShoppingViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        viewModel.output = self
        viewModel.getProduct()
        updateCartDisplay()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        view.addSubview(logoImageView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(cartImageView)
        bottomContainerView.addSubview(lineImageView)
        bottomContainerView.addSubview(totalItemsLabel)
        bottomContainerView.addSubview(totalPriceLabel)
        bottomContainerView.addSubview(actionLabel)
        bottomContainerView.addSubview(arrowImageView)
        view.addSubview(logoutButton)
        view.bringSubviewToFront(logoutButton)
        logoutButton.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
        
        logoImageView.centerXToSuperview()
        logoImageView.topToSuperview(offset: 10, usingSafeArea: true)
        logoImageView.width(122)
        logoImageView.height(103)
        
        tableView.topToBottom(of: logoImageView, offset: 20)
        tableView.leftToSuperview()
        tableView.rightToSuperview()
        tableView.bottomToTop(of: bottomContainerView)
        
        bottomContainerView.leftToSuperview()
        bottomContainerView.rightToSuperview()
        bottomContainerView.bottomToSuperview(usingSafeArea: false)
        bottomContainerView.height(100)
        
        bottomContainerView.addSubview(transparentButton)
        transparentButton.edgesToSuperview()
        
        cartImageView.leadingToSuperview(offset: 24)
        cartImageView.centerYToSuperview(offset: -10)
        cartImageView.width(24)
        cartImageView.height(24)
        
        lineImageView.leadingToTrailing(of: cartImageView, offset: 12)
        lineImageView.centerYToSuperview(offset: -10)
        lineImageView.width(1)
        lineImageView.height(20)
        
        totalItemsLabel.leadingToTrailing(of: lineImageView, offset: 12)
        totalItemsLabel.centerYToSuperview(offset: -20)
        
        totalPriceLabel.leadingToTrailing(of: lineImageView, offset: 12)
        totalPriceLabel.topToBottom(of: totalItemsLabel, offset: 5)
        
        arrowImageView.trailingToSuperview(offset: 16)
        arrowImageView.centerYToSuperview(offset: -10)
        arrowImageView.width(24)
        arrowImageView.height(24)
        
        actionLabel.trailingToLeading(of: arrowImageView, offset: -12   )
        actionLabel.centerYToSuperview(offset: -10)
        
        logoutButton.topToSuperview(usingSafeArea: true)
        logoutButton.rightToSuperview(offset: -20)
        logoutButton.width(40)
        logoutButton.height(40)
        
        transparentButton.addTarget(self, action: #selector(transparentButtonTapped), for: .touchUpInside)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        
        UserDefaultsManager.shared.deleteUser()
        UserDefaultsManager.shared.setLoginStatus(false)
        
        if let navigationController = self.navigationController {
            if let viewControllers = self.navigationController?.viewControllers {
                if let loginController = viewControllers.first(where: { $0 is LoginController }) {
                    navigationController.popToViewController(loginController, animated: true)
                } else {
                    let loginController = LoginController()
                    loginController.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(loginController, animated: true)
                }
            }
        }
        
    }
    
    @objc private func transparentButtonTapped() {
        if (!viewModel.isCartEmpty()) {
            let vc = DetailsViewController()
            vc.viewModel.cart = viewModel.getItemsForSecondViewModel()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "message", message: "cart_is_empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Extensions
extension ShoppingViewController: ProductListViewModelOutputDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func showError(text: String) {
        let alert = UIAlertController(title: "error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}


extension ShoppingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categorizedProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categorizedProducts[section].products.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.categorizedProducts[section].category
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        let product = viewModel.categorizedProducts[indexPath.section].products[indexPath.row]
        cell.configure(with: product)
        
        let quantity = viewModel.getQuantity(for: product)
        cell.quantity = quantity
        
        cell.onAddTap = { [weak self] in
            
            self?.viewModel.addToCart(product: product)
            
            self?.updateCartDisplay()
        }
        
        cell.onRemoveTap = { [weak self] in
            
            self?.viewModel.removeFromCart(product: product)
            
            self?.updateCartDisplay()
        }
        
        return cell
    }
}

extension ShoppingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension ShoppingViewController {
    func updateCartDisplay() {
        DispatchQueue.main.async { [self] in
            let totalItemCount = viewModel.getTotalItemCount()
            let totalPrice = viewModel.getTotalPrice()
            totalItemsLabel.text = "\(totalItemCount) x"
            totalPriceLabel.text = String(format: "%.2f", totalPrice) + "$"
            tableView.reloadData()
        }
        
    }
}

