//
//  LoginViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.07.2023.
//

import UIKit
import IQKeyboardManagerSwift
import TinyConstraints
import ToastViewSwift

final class LoginViewController: UIViewController, LoginViewModelDelegate {
    
    // MARK: - UI Elements
    
    private let LoginLabel : NaLabel = {
        let label = NaLabel()
        label.style = .primary
        label.labelText = "Login"
        label.textColor = UIColor.color(.TextPrimary)

        return label
    }()
 
    private let explanationLabel: NaLabel = {
        let label = NaLabel()
        label.style = .explanation
        label.labelText = "Login or sign up to continue using our app."
        return label
    }()
   
    private let emailTextField: NaTextField = {
        let textField = NaTextField()
        textField.style = .email
        return textField     }()
    
    private let passwordTextField: NaTextField = {
        let textField = NaTextField()
        textField.style = .password
        return textField
    }()
    
    private lazy var forgotPasswordButton : NaButton = {
       let button = NaButton()
        button.style = .forgotPassword
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
   
    private lazy var LoginButton: NaButton = {
       let button = NaButton()
        button.style = .primary
        button.buttonTitle = "Login"
        button.addTarget(self, action: #selector(LoginButtonTapped), for: .touchUpInside)
        return button
    }()
        
    private let signUpNowLabel: NaLabel = {
        let label = NaLabel()
        label.style = .withButton
        label.labelText = "New user?"
        return label
    }()
     
    
    private lazy var signUpNowButton: NaButton = {
       let button = NaButton()
        button.style = .withLabel
        button.buttonTitle = "Sign up now"
        button.addTarget(self, action: #selector(signUpNowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let passwordErrorIcon = NaErrorIcon(frame: .null)
    
    private let passwordErrorLabel = NaErrorLabel()
    
    private let emailErrorIcon = NaErrorIcon(frame: .null)
    
    private let emailErrorLabel = NaErrorLabel()

    private var viewModel: LoginViewModel!
    
    private var router: LoginRouter!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupViewModelAndRouter()
    }
    
    // MARK: - Configuration

    func configureUI(){
        view.backgroundColor = UIColor(named: "System Color-White")
        navigationItem.hidesBackButton = true

        view.addSubview(LoginLabel)
        view.addSubview(explanationLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailErrorIcon)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorIcon)
        view.addSubview(passwordErrorLabel)
        view.addSubview(forgotPasswordButton)
        view.addSubview(LoginButton)
        view.addSubview(signUpNowLabel)
        view.addSubview(signUpNowButton)
        
        LoginLabel.leadingToSuperview().constant = 24
        LoginLabel.topToSuperview().constant = 96
        LoginLabel.trailingToSuperview().constant = -24
        
        explanationLabel.topToBottom(of: LoginLabel, offset: 16)
        explanationLabel.centerXToSuperview()
                                    
        emailTextField.centerXToSuperview()
        emailTextField.topToBottom(of: explanationLabel,offset: 40)
        emailTextField.leadingToSuperview(offset: 24)
        emailTextField.trailingToSuperview(offset: 24)
        self.emailTextField.addPaddingToTextField()
        
        emailErrorIcon.leading(to: emailTextField,offset: 8)
        emailErrorIcon.topToBottom(of: emailTextField,offset: 8)
        
        emailErrorLabel.leading(to: emailErrorIcon,offset: 24)
        emailErrorLabel.centerY(to: emailErrorIcon)
        
        passwordTextField.centerXToSuperview()
        passwordTextField.topToBottom(of: emailErrorLabel,offset: 16)
        passwordTextField.leading(to: emailTextField)
        passwordTextField.trailing(to: emailTextField)
        self.passwordTextField.addPaddingToTextField()
        
        passwordErrorIcon.leading(to: passwordTextField,offset: 8)
        passwordErrorIcon.topToBottom(of: passwordTextField,offset: 8)
        
        passwordErrorLabel.leading(to: passwordErrorIcon,offset: 24)
        passwordErrorLabel.centerY(to: passwordErrorIcon)
        
        forgotPasswordButton.trailing(to: passwordTextField)
        forgotPasswordButton.topToBottom(of: passwordErrorLabel,offset: 12)
        forgotPasswordButton.trailing(to: passwordTextField)

        LoginButton.centerXToSuperview()
        LoginButton.topToBottom(of: forgotPasswordButton,offset: 24)
        LoginButton.leading(to: passwordTextField)
        
        signUpNowLabel.bottomToSuperview(offset: -35)
        signUpNowLabel.leadingToSuperview(offset: 100)
       
        signUpNowButton.leading(to: signUpNowLabel, offset: 80)
        signUpNowButton.centerY(to: signUpNowLabel)
        
        emailTextField.addTarget(self, action: #selector(emailAdressEditingChanged), for: .allEditingEvents)
        emailTextField.addTarget(self, action: #selector(emailAdressEditingDidEnd), for: .editingDidEnd)
        
        passwordTextField.addTarget(self, action: #selector(passwordEditingChanged), for: .allEditingEvents)
        passwordTextField.addTarget(self, action: #selector(passwordEditingDidEnd), for: .editingDidEnd)
    }
    
    private func setupViewModelAndRouter() {
        viewModel = LoginViewModel()
        viewModel.delegate = self
        router = LoginRouter(viewController: self)
    }
    
    // MARK: - LoginViewModelDelegate

    func loginSuccess() {
            let toast = Toast.text("User login Successfully")
            toast.show()
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            let notesViewController = NotesViewController()
            navigationController?.show(notesViewController, sender: nil)
        }
        
        func loginFailure(errorMessage: String) {
            let label = UILabel()
            label.text = "The email and password you entered did not match our records. Please try again"
            label.numberOfLines = 0
            
            let test = AppleToastView(child: label)
            let toast = Toast.custom(view: test)
            toast.show()
        }
    
    // MARK: - Button Actions

    @objc
    func LoginButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        viewModel.loginUser(email: email, password: password)
    }
    
    @objc
    func forgotPasswordButtonTapped(){
        router.navigateToForgotPassword()
    }

    @objc
    func signUpNowButtonTapped(){
        router.navigateToSignUp()
    }
    
    // MARK: - TextField Editing Actions
    
    @objc func emailAdressEditingChanged() {
        emailTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
        if emailTextField.text != nil {
                if !Validation().validateEmail(email: emailTextField.text ?? ""){
                    UIView.animate(withDuration: 0.25) {
                        self.emailErrorIcon.isHidden = false
                        self.emailErrorLabel.isHidden = false
                        self.emailErrorLabel.text = "Email Invalid"
                    }
                    emailTextField.layer.borderColor = UIColor.color(.Red).cgColor
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.emailErrorIcon.isHidden = true
                        self.emailErrorLabel.isHidden = true

                    }
                    emailTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                }
                isEnableLoginButton()
            }
        }

        @objc func emailAdressEditingDidEnd() {
            if emailErrorIcon.isHidden == true && emailErrorLabel.isHidden == true {
                emailTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                emailTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    @objc func passwordEditingChanged() {
        passwordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
        if passwordTextField.text != nil {
                if !Validation().validatePassword(password: passwordTextField.text ?? ""){
                    UIView.animate(withDuration: 0.25) {
                        self.passwordErrorIcon.isHidden = false
                        self.passwordErrorLabel.isHidden = false
                        self.passwordErrorLabel.text = "Password Invalid "
                    }
                    passwordTextField.layer.borderColor = UIColor.color(.Red).cgColor
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.passwordErrorIcon.isHidden = true
                        self.passwordErrorLabel.isHidden = true

                    }
                    passwordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                }
                isEnableLoginButton()
            }
        }

        @objc func passwordEditingDidEnd() {
            if passwordErrorIcon.isHidden == true && passwordErrorLabel.isHidden == true {
                passwordTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                passwordTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    func isEnableLoginButton() {
        if emailErrorIcon.isHidden == true && emailErrorLabel.isHidden == true && passwordErrorIcon.isHidden == true && passwordErrorLabel.isHidden == true && emailTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
                LoginButton.isEnabled = true
            LoginButton.backgroundColor = UIColor.color(.ActionPrimaryEnable)
            LoginButton.setTitleColor(UIColor.color(.White), for: .normal)
            } else {
                LoginButton.isEnabled = false
                LoginButton.backgroundColor = UIColor.color(.ActionPrimaryDisabled)
                LoginButton.setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
            }
        }
}
