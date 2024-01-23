//
//  DetailsViewController.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 18.01.24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255.0, green: 240/255.0, blue: 246/255.0, alpha: 1.0)
        return view
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Total price"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var feeLabel: UILabel = {
        let label = UILabel()
        label.text = "Fee"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "TOTAL"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var balanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var totalPriceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var feeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var deliveryValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("pay".uppercased(), for: .normal)
        button.backgroundColor = UIColor(red: 68/255.0, green: 165/255.0, blue: 255/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
        return button
    }()
    
    var viewModel = DetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        viewModel.delegate = self
        self.updateCartDisplay()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
            ]
        }
        self.title = "payment_page"
        
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(balanceLabel)
        footerView.addSubview(totalPriceLabel)
        footerView.addSubview(feeLabel)
        footerView.addSubview(deliveryLabel)
        footerView.addSubview(totalLabel)
        footerView.addSubview(balanceValueLabel)
        footerView.addSubview(totalPriceValueLabel)
        footerView.addSubview(feeValueLabel)
        footerView.addSubview(deliveryValueLabel)
        footerView.addSubview(totalValueLabel)
        footerView.addSubview(checkoutButton)
        
        tableView.edgesToSuperview(excluding: .bottom)
        
        tableView.bottomToTop(of: footerView)
        
        footerView.edgesToSuperview(excluding: .top, usingSafeArea: true)
        footerView.height(210)
        
        balanceLabel.topToSuperview(offset: 20)
        balanceLabel.leftToSuperview(offset: 20)
        
        totalPriceLabel.topToBottom(of: balanceLabel, offset: 10)
        totalPriceLabel.leftToSuperview(offset: 20)
        
        feeLabel.topToBottom(of: totalPriceLabel, offset: 10)
        feeLabel.leftToSuperview(offset: 20)
        
        deliveryLabel.topToBottom(of: feeLabel, offset: 10)
        deliveryLabel.leftToSuperview(offset: 20)
        
        totalLabel.topToBottom(of: deliveryLabel, offset: 10)
        totalLabel.leftToSuperview(offset: 20)
        
        balanceValueLabel.topToSuperview(offset: 20)
        balanceValueLabel.rightToSuperview(offset: -20)
        
        totalPriceValueLabel.topToBottom(of: balanceValueLabel, offset: 10)
        totalPriceValueLabel.rightToSuperview(offset: -20)
        
        feeValueLabel.topToBottom(of: totalPriceValueLabel, offset: 10)
        feeValueLabel.rightToSuperview(offset: -20)
        
        deliveryValueLabel.topToBottom(of: feeValueLabel, offset: 10)
        deliveryValueLabel.rightToSuperview(offset: -20)
        
        totalValueLabel.topToBottom(of: deliveryValueLabel, offset: 10)
        totalValueLabel.rightToSuperview(offset: -20)
        
        checkoutButton.height(55)
        checkoutButton.leftToSuperview(offset: 20)
        checkoutButton.rightToSuperview(offset: -20)
        checkoutButton.bottomToSuperview(offset: -10)
    }
    
    // MARK: - Action
    @objc private func didTapCheckoutButton() {
        guard let user = UserDefaultsManager.shared.getUser() else { return }
        let balance = user.balance
        let price = self.viewModel.calculateTotalAmount()
        let fee = price * 0.10
        let total = price + fee + 50.0
        var status: Status?
        
        if (balance < total) {
            status = .failure
        } else {
            status = .success
            viewModel.pay()
        }
        
        let paymentViewController = PaymentViewController()
        paymentViewController.viewModel.status = status
        self.present(paymentViewController, animated: true, completion: nil)
    }
    
}

// MARK: - Extension
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cart?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as? DetailsTableViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        
        guard let cartItem = viewModel.cart?[indexPath.row] else {
            fatalError("CartItem at indexPath is nil")
        }
        
        let product = cartItem.product
        let quantity = cartItem.quantity
        cell.configure(with: product, with: quantity)
        
        return cell
        
    }
    
}

extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension DetailsViewController: ProductDetailViewModelDelegate {
    func reloadData(newBalance: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.balanceValueLabel.text = String(format: "%.2f", newBalance) + "$"
        }
    }
    
    func showError(text: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "error", message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension DetailsViewController {
    func updateCartDisplay() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let user = UserDefaultsManager.shared.getUser() else {return}
            let balance = user.balance
            let totalPrice = self.viewModel.calculateTotalAmount()
            let fee = totalPrice * 0.10
            let total = totalPrice + fee + 50.0
            balanceValueLabel.text = String(format: "%.2f", balance) + "$"
            totalPriceValueLabel.text = String(format: "%.2f", totalPrice) + "$"
            feeValueLabel.text = String(format: "%.2f", fee) + "$"
            deliveryValueLabel.text = "50.00 $"
            totalValueLabel.text = String(format: "%.2f", total) + "$"
        }
        
    }
}
