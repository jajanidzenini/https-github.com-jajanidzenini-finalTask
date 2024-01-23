//
//  LoginController.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 15.01.24.
//

import UIKit
import TinyConstraints
import AVFAudio

class LoginController: UIViewController, UserViewModelDelegate {
    func loginDidSucceed(user: User) {
        <#code#>
    }
    
    func loginDidFail(withError error: LoginError) {
        <#code#>
    }
    
    
    // MARK: - Properties
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "welcome"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(red: 217/255, green: 219/255, blue: 233/255, alpha: 1).cgColor
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightViewMode = .always
        return textField
    }()

    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(red: 217/255, green: 219/255, blue: 233/255, alpha: 1).cgColor
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login".uppercased(), for: .normal)
        button.backgroundColor = UIColor(red: 68/255.0, green: 165/255.0, blue: 255/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var viewModel: UserViewModel = UserViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        viewModel.delegate = self
    }

    
    // MARK: - Setup
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(activityIndicator)
        
        welcomeLabel.topToSuperview(offset: 50, usingSafeArea: true)
        welcomeLabel.centerXToSuperview()
        
        logoImageView.topToBottom(of: welcomeLabel, offset: 20)
        logoImageView.centerXToSuperview()
        logoImageView.width(200)
        logoImageView.height(150)
        
        emailTextField.topToBottom(of: logoImageView, offset: 35)
        emailTextField.leftToSuperview(offset: 16)
        emailTextField.rightToSuperview(offset: -16)
        emailTextField.height(57)
        
        passwordTextField.topToBottom(of: emailTextField, offset: 20)
        passwordTextField.leftToSuperview(offset: 16)
        passwordTextField.rightToSuperview(offset: -16)
        passwordTextField.height(57)
        
        loginButton.topToBottom(of: passwordTextField, offset: 20)
        loginButton.leftToSuperview(offset: 16)
        loginButton.rightToSuperview(offset: -16)
        loginButton.height(57)
        
        activityIndicator.topToBottom(of: loginButton, offset: 20)
        activityIndicator.centerXToSuperview()
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.loginUser(email: email, password: password)
    }
    
}

