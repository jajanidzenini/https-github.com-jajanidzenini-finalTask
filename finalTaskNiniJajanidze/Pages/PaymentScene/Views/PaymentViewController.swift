//
//  PaymentViewController.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 20.01.24.
//

import UIKit

class PaymentViewController: UIViewController  {
    
    // MARK: - Properties
    private lazy var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "payment_error".uppercased()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("return_back".uppercased(), for: .normal)
        button.backgroundColor = UIColor(red: 68/255.0, green: 165/255.0, blue: 255/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    var viewModel = PaymentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.delegate = self
        viewModel.viewIsLoaded()
    }
    
    // MARK: - Setup
    private func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(statusImageView)
        view.addSubview(statusLabel)
        view.addSubview(backButton)
        
        statusImageView.centerXToSuperview()
        statusImageView.topToSuperview(offset: 120, usingSafeArea: true)
        statusImageView.width(135)
        statusImageView.height(135)
        
        statusLabel.topToBottom(of: statusImageView, offset: 20)
        statusLabel.leftToSuperview(offset: 16)
        statusLabel.rightToSuperview(offset: -16)
        
        backButton.bottomToSuperview(offset: -10, usingSafeArea: true)
        backButton.leftToSuperview(offset: 16)
        backButton.rightToSuperview(offset: -16)
        backButton.height(55)
        
    }
    
    // MARK: - Action
    @objc private func didTapBackButton() {
        guard let navigationController = presentingViewController as? UINavigationController else {
            print("Presenting view controller is not a navigation controller")
            return
        }
        
        dismiss(animated: true, completion: {
            let shoppingViewController = ShoppingViewController()
            DispatchQueue.main.async {
                navigationController.pushViewController(shoppingViewController, animated: true)
            }
        })
        
    }
    
}

// MARK: - Extension
extension PaymentViewController: PaymentViewModelDelegate {
    func paymentDidSucceed() {
        DispatchQueue.main.async { [weak self] in
            self?.statusImageView.image = UIImage(named: "ok")
            self?.statusLabel.text = "payment_success".uppercased()
            }
    }
    
    func paymentDidFail() {
        DispatchQueue.main.async { [weak self] in
            self?.statusImageView.image = UIImage(named: "close")
            self?.statusLabel.text = "payment_error".uppercased()
        }
    }
    
}
