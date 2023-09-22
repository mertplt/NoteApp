//
//  ForgotPasswordViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.07.2023.
//

import UIKit
import IQKeyboardManagerSwift
import TinyConstraints
import ToastViewSwift

final class ForgotPasswordViewController: UIViewController, ForgotPasswordViewModelDelegate {
    
    // MARK: - UI Elements

    private let forgotPasswordLabel: NaLabel = {
        let label = NaLabel()
        label.style = .primary
        label.labelText = "Forgot Password?"
        return label
    }()
        
    private let explanationLabel: NaLabel = {
        let label = NaLabel()
        label.style = .explanation
        label.labelText = "Confirm your email and we will send the instructions."
        return label

    }()

    private let emailTextField: NaTextField = {
        let textField = NaTextField()
        textField.style = .email
        return textField
    }()
    
    private lazy var ResetPasswordButton: NaButton = {
       let button = NaButton()
        button.style = .primary
        button.buttonTitle = "Reset Password"
        button.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let ErrorIcon = NaErrorIcon(frame: .null)
    
    private let ErrorLabel = NaErrorLabel()
    
    private var viewModel: ForgotPasswordViewModel!
    
    private var router: ForgotPasswordRouter!


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupViewModelAndRouter()
    }
    
    // MARK: - Configuration

    func configureUI(){
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Text Primary")
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backBarButtonItem.tintColor = UIColor(named: "Text Primary")
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        view.addSubview(forgotPasswordLabel)
        view.addSubview(explanationLabel)
        view.addSubview(emailTextField)
        view.addSubview(ErrorIcon)
        view.addSubview(ErrorLabel)
        view.addSubview(ResetPasswordButton)
        
        forgotPasswordLabel.leadingToSuperview().constant = 24
        forgotPasswordLabel.topToSuperview().constant = 96
        forgotPasswordLabel.trailingToSuperview().constant = -24
        
        explanationLabel.topToBottom(of: forgotPasswordLabel, offset: 16)
        explanationLabel.centerXToSuperview()
        
        emailTextField.centerXToSuperview()
        emailTextField.topToBottom(of: explanationLabel,offset: 40)
        emailTextField.leadingToSuperview(offset: 24)
        emailTextField.trailingToSuperview(offset: 24)
        self.emailTextField.addPaddingToTextField()
        
        ErrorIcon.leading(to: emailTextField,offset: 8)
        ErrorIcon.topToBottom(of: emailTextField,offset: 8)
        
        ErrorLabel.leading(to: ErrorIcon,offset: 24)
        ErrorLabel.centerY(to: ErrorIcon)
        
        ResetPasswordButton.centerXToSuperview()
        ResetPasswordButton.topToBottom(of: ErrorLabel,offset: 24)
        ResetPasswordButton.leading(to: emailTextField)
        
        emailTextField.addTarget(self, action: #selector(emailAdressEditingChanged), for: .allEditingEvents)
        emailTextField.addTarget(self, action: #selector(emailAdressEditingDidEnd), for: .editingDidEnd)
        
    }
    
    private func setupViewModelAndRouter() {
        viewModel = ForgotPasswordViewModel()
        viewModel.delegate = self
        router = ForgotPasswordRouter(viewController: self)
    }
    
    // MARK: - Button Actions
    
    @objc
    func resetPasswordButtonTapped() {
        let email = emailTextField.text ?? ""
        viewModel.resetPassword(email: email)
    }
    
    @objc
    func backButtonTapped(){
        router.navigateToLogin()
    }
    
    // MARK: - TextField Editing Actions

    @objc func emailAdressEditingChanged() {
        emailTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
        if emailTextField.text != nil {
                if !Validation().validateEmail(email: emailTextField.text ?? ""){
                    UIView.animate(withDuration: 0.25) {
                        self.ErrorIcon.isHidden = false
                        self.ErrorLabel.isHidden = false
                        self.ErrorLabel.text = "Email Invalid"
                    }
                    emailTextField.layer.borderColor = UIColor.color(.Red).cgColor
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.ErrorIcon.isHidden = true
                        self.ErrorLabel.isHidden = true

                    }
                    emailTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                }
                isEnableForgotPasswordButton()
            }
        }

        @objc func emailAdressEditingDidEnd() {
            if ErrorIcon.isHidden == true && ErrorLabel.isHidden == true {
                emailTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                emailTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    func isEnableForgotPasswordButton() {
        if ErrorIcon.isHidden == true && ErrorLabel.isHidden == true && emailTextField.text!.count > 0  {
                ResetPasswordButton.isEnabled = true
            ResetPasswordButton.backgroundColor = UIColor.color(.ActionPrimaryEnable)
            ResetPasswordButton.setTitleColor(UIColor.color(.White), for: .normal)
            } else {
                ResetPasswordButton.isEnabled = false
                ResetPasswordButton.backgroundColor = UIColor.color(.ActionPrimaryDisabled)
                ResetPasswordButton.setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
            }
        }

    func resetPasswordSuccess() {
        router.showResetPasswordSuccess(email: emailTextField.text ?? "")

    }
    
    func resetPasswordFailure(errorMessage: String) {
        router.showResetPasswordError(errorMessage: errorMessage)
    }
}
