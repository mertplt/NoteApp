//
//  ChangePasswordViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 26.07.2023.
//

import UIKit
import ToastViewSwift

final class ChangePasswordViewController: UIViewController {
    
    // MARK: - UI Elements

    private let menuButton = UIButton(type: .custom)
    
    private let NavigationBarTitle: NaLabel = {
       let label = NaLabel()
        label.style = .explanation
        label.textColor = UIColor.color(.TextPrimary)
        label.labelText = "Change Password"
        return label
    }()
    
    private let passwordTextField: NaTextField = {
        let textField = NaTextField()
        textField.style = .password
        return textField
    }()
        
    private let newPassordTextField: NaTextField = {
        let textField = NaTextField()
        textField.style = .password
        textField.textContentTypeValue = .newPassword
        textField.placeholderText = "New Password"
        return textField
    }()
    
    private let retypePassordTextField: NaTextField = {
        let textField = NaTextField()
        textField.style = .password
        textField.placeholderText = "Retype New Password"
        return textField
    }()
    
    private lazy var saveButton: NaButton = {
        let button = NaButton()
        button.style = .primary
        button.buttonTitle = "Save"
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let passwordErrorIcon = NaErrorIcon(frame: .null)
    private let passwordErrorLabel = NaErrorLabel()
    private let newPasswordErrorIcon = NaErrorIcon(frame: .null)
    private let newPasswordLabel = NaErrorLabel()
    private let retypePasswordErrorIcon = NaErrorIcon(frame: .null)
    private let retypePasswordLabel = NaErrorLabel()
    
    var viewModel: ChangePasswordViewModel!
    
    private var router: ChangePasswordRouter!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelAndRouter()
        configureUI()
    }
    
    // MARK: - UI Configuration

    func configureUI(){
        
        view.addSubview(menuButton)
        view.addSubview(NavigationBarTitle)
        view.addSubview(saveButton)
        view.addSubview(retypePassordTextField)
        view.addSubview(passwordTextField)
        view.addSubview(newPasswordErrorIcon)
        view.addSubview(newPasswordLabel)
        view.addSubview(passwordErrorIcon)
        view.addSubview(passwordErrorLabel)
        view.addSubview(retypePasswordErrorIcon)
        view.addSubview(retypePasswordLabel)
        view.addSubview(newPassordTextField)
        
        view.backgroundColor = UIColor.color(.White)
        
        menuButton.setImage(UIImage(named: "ic_menu"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action:#selector(menuButtonTapped), for:.touchUpInside)
        let menuBarButtonItem=UIBarButtonItem(customView :menuButton)

        passwordTextField.topToSuperview().constant = 112
        passwordTextField.centerXToSuperview()
        passwordTextField.leadingToSuperview().constant = 24
        passwordTextField.trailingToSuperview().constant = -24
        
        passwordErrorIcon.leading(to: passwordTextField,offset: 8)
        passwordErrorIcon.topToBottom(of: passwordTextField,offset: 8)
        
        passwordErrorLabel.leading(to: passwordErrorIcon,offset: 24)
        passwordErrorLabel.centerY(to: passwordErrorIcon)
        
        newPassordTextField.centerXToSuperview()
        newPassordTextField.topToBottom(of: passwordErrorLabel,offset: 10)
        newPassordTextField.leading(to: passwordTextField)
        newPassordTextField.trailing(to: passwordTextField)
        
        newPasswordErrorIcon.leading(to: newPassordTextField,offset: 8)
        newPasswordErrorIcon.topToBottom(of: newPassordTextField,offset: 12)
        
        newPasswordLabel.leading(to: newPasswordErrorIcon,offset: 24)
        newPasswordLabel.centerY(to: newPasswordErrorIcon)
        
        retypePassordTextField.centerXToSuperview()
        retypePassordTextField.topToBottom(of: newPasswordLabel,offset: 10)
        retypePassordTextField.leading(to: newPassordTextField)
        retypePassordTextField.trailing(to: newPassordTextField)
        
        retypePasswordErrorIcon.leading(to: retypePassordTextField,offset: 8)
        retypePasswordErrorIcon.topToBottom(of: retypePassordTextField,offset: 12)
        
        retypePasswordLabel.leading(to: retypePasswordErrorIcon,offset: 24)
        retypePasswordLabel.centerY(to: retypePasswordErrorIcon)
        
        saveButton.centerXToSuperview()
        saveButton.topToBottom(of: retypePasswordLabel,offset: 10)
        saveButton.leading(to: retypePassordTextField)
        
        passwordTextField.addTarget(self, action: #selector(passwordEditingChanged), for: .allEditingEvents)
        passwordTextField.addTarget(self, action: #selector(passwordEditingDidEnd), for: .editingDidEnd)

        newPassordTextField.addTarget(self, action: #selector(newPasswordEditingChanged), for: .allEditingEvents)
        newPassordTextField.addTarget(self, action: #selector(newPasswordEditingDidEnd), for: .editingDidEnd)

        retypePassordTextField.addTarget(self, action: #selector(retypePasswordEditingChanged), for: .allEditingEvents)
        retypePassordTextField.addTarget(self, action: #selector(retypePasswordEditingDidEnd), for: .editingDidEnd)

        navigationItem.leftBarButtonItems = [menuBarButtonItem]
        navigationItem.titleView = NavigationBarTitle

    }
    
    private func setupViewModelAndRouter(){
        viewModel = ChangePasswordViewModel()
        router = ChangePasswordRouter(viewController: self)
    }
    
    // MARK: - Button Actions

    @objc
    func saveButtonTapped() {
        viewModel.changePassword { isSuccess in
            if isSuccess {
                let toast = Toast.default(
                    image: UIImage(named: "ic_success")!,
                    title: "Password Changed Successfully",
                    subtitle: "You can now use your new password."
                )
                toast.show()
            } else {
                let toast = Toast.default(
                    image: UIImage(named: "ic_error64x64")!,
                    title: "Password Change Failed",
                    subtitle: "Please try again."
                )
                toast.show()
            }
        }
    }

    @objc
    func menuButtonTapped(){
        router.navigateBack()
    }
    
    // MARK: - TextField Editing Actions

    @objc func passwordEditingChanged() {
        viewModel.currentPassword = passwordTextField.text ?? ""
        
        passwordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
        if passwordTextField.text != nil {
                if !Validation().validatePassword(password: passwordTextField.text ?? ""){
                    UIView.animate(withDuration: 0.25) {
                        self.passwordErrorIcon.isHidden = false
                        self.passwordErrorLabel.isHidden = false
                        self.passwordErrorLabel.text = "Password Invalid"
                    }
                    passwordTextField.layer.borderColor = UIColor.color(.Red).cgColor
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.passwordErrorIcon.isHidden = true
                        self.passwordErrorLabel.isHidden = true

                    }
                    passwordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                }
                isEnableSaveButton()
            }
        }
    
    @objc func passwordEditingDidEnd() {
            if passwordErrorIcon.isHidden == true && passwordErrorLabel.isHidden == true {
                passwordTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                passwordTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    @objc func newPasswordEditingChanged() {
        viewModel.newPassword = newPassordTextField.text ?? ""
        
        newPassordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
        if newPassordTextField.text != nil {
                if !Validation().validatePassword(password: newPassordTextField.text ?? ""){
                    UIView.animate(withDuration: 0.25) {
                        self.newPasswordErrorIcon.isHidden = false
                        self.newPasswordLabel.isHidden = false
                        self.newPasswordLabel.text = "New Password Invalid"
                    }
                    newPassordTextField.layer.borderColor = UIColor.color(.Red).cgColor
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.newPasswordErrorIcon.isHidden = true
                        self.newPasswordLabel.isHidden = true

                    }
                    newPassordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                }
                isEnableSaveButton()
            }
        }

        @objc func newPasswordEditingDidEnd() {
            if newPasswordErrorIcon.isHidden == true && newPasswordLabel.isHidden == true {
                newPassordTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                newPassordTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    @objc func retypePasswordEditingChanged() {
        viewModel.confirmPassword = retypePassordTextField.text ?? ""

        retypePassordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
        if retypePassordTextField.text != nil {
                if !Validation().validatePassword(password: retypePassordTextField.text ?? ""){
                    UIView.animate(withDuration: 0.25) {
                        self.retypePasswordErrorIcon.isHidden = false
                        self.retypePasswordLabel.isHidden = false
                        self.retypePasswordLabel.text = "Retype Password Invalid "
                    }
                    retypePassordTextField.layer.borderColor = UIColor.color(.Red).cgColor
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.retypePasswordErrorIcon.isHidden = true
                        self.retypePasswordLabel.isHidden = true

                    }
                    retypePassordTextField.layer.borderColor = UIColor.color(.ActionPrimaryEnable).cgColor
                }
                isEnableSaveButton()
            }
        }

        @objc func retypePasswordEditingDidEnd() {
            if retypePasswordErrorIcon.isHidden == true && retypePasswordLabel.isHidden == true {
                retypePassordTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                retypePassordTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    func isEnableSaveButton() {
        if viewModel.isSaveButtonEnabled {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.color(.ActionPrimaryEnable)
            saveButton.setTitleColor(UIColor.color(.White), for: .normal)
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.color(.ActionPrimaryDisabled)
            saveButton.setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
        }
    }
}
