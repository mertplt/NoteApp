//
//  RegisterViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 12.07.2023.
//

import UIKit
import TinyConstraints
import IQKeyboardManagerSwift
import ToastViewSwift

final class RegisterViewController: UIViewController, RegisterViewModelDelegate {
    
    // MARK: - UI Elements

     private let signUpLabel: NaLabel = {
         let label = NaLabel()
         label.style = .primary
         label.labelText = "Sign Up"
         label.textColor = UIColor.color(.TextPrimary)
         return label
     }()
  
     private let explanationLabel: NaLabel = {
         let label = NaLabel()
         label.style = .explanation
         label.labelText = "Login or sign up to continue using our app."
         return label

     }()
    
    
     private let nameTextField: NaTextField = {
         let textField = NaTextField()
         textField.style = .name
         return textField
     }()
     
        
     private let emailTextField: NaTextField = {
         let textField = NaTextField()
         textField.style = .email
         return textField
     }()

     
     private let passwordTextField: NaTextField = {
         let textField = NaTextField()
         textField.style = .password
         return textField
     }()
     
     
     private lazy var forgotPasswordButton: NaButton = {
         let button = NaButton()
         button.style = .forgotPassword
         button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
         return button
     }()
     
     private lazy var signUpButton: NaButton = {
         let button = NaButton()
         button.style = .primary
         button.buttonTitle = "Sign Up"
         button.addTarget(self, action: #selector(SignUpButtonTapped), for: .touchUpInside)
         return button
     }()
     
     private let signInNowLabel: NaLabel = {
         let label = NaLabel()
         label.style = .withButton
         label.labelText = "Already have an account?"
         return label
     }()
    
     private lazy var signInNowButton: NaButton = {
         let button = NaButton()
         button.style = .withLabel
         button.buttonTitle = "Sign in now"
         button.addTarget(self, action: #selector(signInNowButtonTapped), for: .touchUpInside)
         return button
     }()
        
     private let passwordErrorIcon = NaErrorIcon(frame: .null)

     private let passwordErrorLabel = NaErrorLabel()
     
     private let emailErrorIcon = NaErrorIcon(frame: .null)

     private let emailErrorLabel = NaErrorLabel()
     
     private let nameErrorIcon = NaErrorIcon(frame: .null)
     
     private let nameErrorLabel = NaErrorLabel()
     
     private var viewModel: RegisterViewModel!
     private var router: RegisterRouter!
          
     override func viewDidLoad() {
         super.viewDidLoad()
         configureUI()
         configureKeyboardSettings()
         setupViewModelAndRouter()
     }
            
    func configureUI(){
        navigationItem.hidesBackButton = true

        view.addSubview(signUpLabel)
        view.addSubview(explanationLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameErrorIcon)
        view.addSubview(nameErrorLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailErrorIcon)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorIcon)
        view.addSubview(passwordErrorLabel)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signUpButton)
        view.addSubview(signInNowLabel)
        view.addSubview(signInNowButton)
       
        view.backgroundColor = UIColor.color(.White)
        
        //MARK: constraints
        
        signUpLabel.leadingToSuperview().constant = 24
        signUpLabel.topToSuperview().constant = 96
        signUpLabel.trailingToSuperview().constant = -24
        
        explanationLabel.topToBottom(of: signUpLabel, offset: 16)
        explanationLabel.centerXToSuperview()
        
        nameTextField.centerXToSuperview()
        nameTextField.topToBottom(of: explanationLabel,offset: 40)
        nameTextField.leadingToSuperview(offset: 24)
        nameTextField.trailingToSuperview(offset: 24)
        self.nameTextField.addPaddingToTextField()
        
        nameErrorIcon.leading(to: nameTextField,offset: 8)
        nameErrorIcon.topToBottom(of: nameTextField,offset: 8)
        
        nameErrorLabel.leading(to: nameErrorIcon,offset: 24)
        nameErrorLabel.centerY(to: nameErrorIcon)
        
        emailTextField.centerXToSuperview()
        emailTextField.topToBottom(of: nameErrorLabel,offset: 10)
        emailTextField.leading(to: nameTextField)
        emailTextField.trailing(to: nameTextField)
        self.emailTextField.addPaddingToTextField()
        
        emailErrorIcon.leading(to: emailTextField,offset: 8)
        emailErrorIcon.topToBottom(of: emailTextField,offset: 12)
        
        emailErrorLabel.leading(to: emailErrorIcon,offset: 24)
        emailErrorLabel.centerY(to: emailErrorIcon)

        passwordTextField.centerXToSuperview()
        passwordTextField.topToBottom(of: emailErrorLabel,offset: 12)
        passwordTextField.leading(to: nameTextField)
        passwordTextField.trailing(to: nameTextField)
        self.passwordTextField.addPaddingToTextField()
        
        passwordErrorIcon.leading(to: passwordTextField,offset: 8)
        passwordErrorIcon.topToBottom(of: passwordTextField,offset: 12)
        
        passwordErrorLabel.leading(to: passwordErrorIcon,offset: 24)
        passwordErrorLabel.centerY(to: passwordErrorIcon)
        
        forgotPasswordButton.trailing(to: passwordTextField)
        forgotPasswordButton.topToBottom(of: passwordErrorLabel,offset: 8)
        forgotPasswordButton.trailing(to: nameTextField)

        signUpButton.centerXToSuperview()
        signUpButton.topToBottom(of: forgotPasswordButton,offset: 24)
        signUpButton.leading(to: passwordTextField)
        
        signInNowLabel.bottomToSuperview(offset: -35)
        signInNowLabel.leadingToSuperview(offset: 52)
       
        signInNowButton.leading(to: signInNowLabel, offset: 190)
        signInNowButton.centerY(to: signInNowLabel)
        
        nameTextField.addTarget(self, action: #selector(fullNameEditingChanged), for: .allEditingEvents)
                nameTextField.addTarget(self, action: #selector(fullNameEditingDidEnd), for: .editingDidEnd)
        
        emailTextField.addTarget(self, action: #selector(emailAdressEditingChanged), for: .allEditingEvents)
        emailTextField.addTarget(self, action: #selector(emailAdressEditingDidEnd), for: .editingDidEnd)
        
        passwordTextField.addTarget(self, action: #selector(passwordEditingChanged), for: .allEditingEvents)
        passwordTextField.addTarget(self, action: #selector(passwordEditingDidEnd), for: .editingDidEnd)
    }
    
    private func setupViewModelAndRouter() {
        viewModel = RegisterViewModel()
        router = RegisterRouter(viewController: self)
        viewModel.delegate = self
    }
    
    private func configureKeyboardSettings() {
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "Action Primary -100")
        IQKeyboardManager.shared.placeholderColor = UIColor(named: "Action Primary-50")
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Bitti"
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
    // MARK: - Button Actions

    @objc
    func signInNowButtonTapped() {
        router.navigateToLogin()
    }
    
    @objc
    func forgotPasswordButtonTapped() {
        router.navigateToForgotPassword()
    }
     
    @objc func SignUpButtonTapped() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        viewModel.registerUser(name: name, email: email, password: password)
    }
    
     
     @objc func fullNameEditingChanged() {
         nameTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
         if nameTextField.text != nil {
                 if !Validation().validateName(name: nameTextField.text ?? "") {
                     UIView.animate(withDuration: 0.25) {
                         self.nameErrorIcon.isHidden = false
                         self.nameErrorLabel.isHidden = false
                         self.nameErrorLabel.text = "Name Invalid"
                     }
                     nameTextField.layer.borderColor = UIColor.color(.Red).cgColor
                 } else {
                     UIView.animate(withDuration: 0.25) {
                         self.nameErrorIcon.isHidden = true
                         self.nameErrorLabel.isHidden = true

                     }
                     nameTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                 }
                 isEnableSignUpButton()
             }
         }

         @objc func fullNameEditingDidEnd() {
             if nameErrorIcon.isHidden == true && nameErrorLabel.isHidden == true {
                 nameTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
             } else {
                 nameTextField.layer.borderColor = UIColor.color(.Red).cgColor
             }
         }
     
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
                 isEnableSignUpButton()
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
                 isEnableSignUpButton()
             }
         }

         @objc func passwordEditingDidEnd() {
             if passwordErrorIcon.isHidden == true && passwordErrorLabel.isHidden == true {
                 passwordTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
             } else {
                 passwordTextField.layer.borderColor = UIColor.color(.Red).cgColor
             }
         }
     

     func isEnableSignUpButton() {
         if nameErrorIcon.isHidden == true && nameErrorLabel.isHidden == true && emailErrorIcon.isHidden == true && emailErrorLabel.isHidden == true && passwordErrorIcon.isHidden == true && passwordErrorLabel.isHidden == true && emailTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
                 signUpButton.isEnabled = true
             signUpButton.backgroundColor = UIColor.color(.ActionPrimaryEnable)
             signUpButton.setTitleColor(UIColor.color(.White), for: .normal)
             } else {
                 signUpButton.isEnabled = false
                 signUpButton.backgroundColor = UIColor.color(.ActionPrimaryDisabled)
                 signUpButton.setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
             }
         }
    
    func registrationSuccess() {
        let toast = Toast.default(
                   image: UIImage(named: "ic_success")!,
                   title: "User Registration Successful"
               )
               toast.show()
               
               UserDefaults.standard.set(true, forKey: "isLoggedIn")
               
            router.navigateToNotes()
    }
    
    func registrationFailure(errorMessage: String) {
        let toast = Toast.default(
            image: UIImage(named: "ic_error64x64")!,
            title: "User Registration Failed.",
            subtitle: errorMessage
        )
        toast.show()
    }
}

extension UITextField {
    func addPaddingToTextField() {
        let paddingView: UIView = UIView.init(frame: CGRect(x: 18, y: 18, width: 18, height: 18))
        self.leftView = paddingView;
        self.leftViewMode = .always;
        self.rightView = paddingView;
        self.rightViewMode = .always;
    }
}
