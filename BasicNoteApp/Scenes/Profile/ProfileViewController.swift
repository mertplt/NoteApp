//
//  ProfileViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 12.07.2023.
//

import UIKit
import ToastViewSwift

final class ProfileViewController: UIViewController {
    
    private let menuButton = UIButton(type: .custom)
    
    private let NavigationBarTitle: NaLabel = {
       let label = NaLabel()
        label.style = .explanation
        label.textColor = UIColor.color(.TextPrimary)
        label.labelText = "Profile"
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
    
    private lazy var saveButton: NaButton = {
        let button = NaButton()
        button.style = .primary
        button.buttonTitle = "Save"
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changePasswordButton: NaButton = {
        let button = NaButton()
        button.style = .forgotPassword
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
        button.titleLabel?.font = UIFont.font(.interSemiBold, size: .small)
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signOutButton: NaButton = {
        let button = NaButton()
        button.style = .forgotPassword
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.color(.Red), for: .normal)
        button.titleLabel?.font = UIFont.font(.interSemiBold, size: .small)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameErrorIcon = NaErrorIcon(frame: .null)
    private let nameErrorLabel = NaErrorLabel()
    private let emailErrorIcon = NaErrorIcon(frame: .null)
    private let emailErrorLabel = NaErrorLabel()
    private var viewModel: ProfileViewModel!
    private var router: ProfileRouter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelAndRouter()
        configureUI()
    }
    
    func configureUI(){
        view.addSubview(menuButton)
        view.addSubview(NavigationBarTitle)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(saveButton)
        view.addSubview(changePasswordButton)
        view.addSubview(signOutButton)
        view.addSubview(nameErrorIcon)
        view.addSubview(nameErrorLabel)
        view.addSubview(emailErrorIcon)
        view.addSubview(emailErrorLabel)
        
        view.backgroundColor = UIColor.color(.White)
        
        menuButton.setImage(UIImage(named: "ic_menu"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action:#selector(menuButtonTapped), for:.touchUpInside)
        
         let menuBarButtonItem=UIBarButtonItem(customView :menuButton)

         nameTextField.topToSuperview().constant = 112
         nameTextField.centerXToSuperview()
         nameTextField.leadingToSuperview().constant = 24
         nameTextField.trailingToSuperview().constant = -24
        
         nameErrorIcon.leading(to: nameTextField,offset: 8)
         nameErrorIcon.topToBottom(of: nameTextField,offset: 8)

         nameErrorLabel.leading(to: nameErrorIcon,offset: 24)
         nameErrorLabel.centerY(to: nameErrorIcon)

         emailTextField.centerXToSuperview()
         emailTextField.topToBottom(of:nameErrorLabel,offset :10 )
         emailTextField.leading(to:nameTextField )
         emailTextField.trailing(to:nameTextField )
         self.emailTextField.addPaddingToTextField()

         emailErrorIcon.leading(to :emailTextField ,offset :8 )
         emailErrorIcon.topToBottom(of :emailTextField ,offset :12 )

         emailErrorLabel.leading(to :emailErrorIcon ,offset :24 )
         emailErrorLabel.centerY(to :emailErrorIcon )

         saveButton.centerXToSuperview()
         saveButton.topToBottom(of :emailErrorLabel ,offset :10 )
         saveButton.leading(to :emailTextField )

         changePasswordButton.centerXToSuperview()
         changePasswordButton.topToBottom(of :saveButton ,offset :16 )

         signOutButton.centerXToSuperview()
         signOutButton.topToBottom(of :changePasswordButton ,offset :8 )

         nameTextField.addTarget(self, action: #selector(fullNameEditingChanged), for: .allEditingEvents)
         nameTextField.addTarget(self, action: #selector(fullNameEditingDidEnd), for: .editingDidEnd)

         emailTextField.addTarget(self, action: #selector(emailAdressEditingChanged), for: .allEditingEvents)
         emailTextField.addTarget(self, action: #selector(emailAdressEditingDidEnd), for: .editingDidEnd)

         navigationItem.leftBarButtonItems=[menuBarButtonItem]
         navigationItem.titleView = NavigationBarTitle

        viewModel.fetchUserData()
    }
    
    private func setupViewModelAndRouter(){
        viewModel = ProfileViewModel { [weak self] in self?.updateUI() }
        router = ProfileRouter(viewController: self)
        }
    
    private func updateUI() {
        switch viewModel.state {
        case .loading:
            break
        case .loaded(let user):
            self.emailTextField.text = user.email
            self.nameTextField.text = user.fullName
        case .error(let error):
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Button Actions

    @objc func changePasswordButtonTapped(){
        router.navigateToChangePassword()
    }
    
    @objc func signOutButtonTapped(){
        router.navigateToRegister()
    }
    
    @objc func saveButtonTapped(){
        
        viewModel.updateUserData(fullName: nameTextField.text!, email: emailTextField.text!) { result in
            switch result {
            case .success:
                let toast = Toast.default(
                    image: UIImage(named: "ic_success")!,
                    title: "Profile Updated "
                )
                
                toast.show()
            case .failure(let error):
                let toast = Toast.default(
                    image: UIImage(named: "ic_error64x64")!,
                    title: "Failed to update profile.",
                    subtitle: "Please try again"
                    
                )
                toast.show()
                print(error.localizedDescription)
            }
        }
        
    }
    
    @objc func menuButtonTapped(){
        router.navigateToNotes()
    }
    
    // MARK: - TextField Editing Actions
    
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
                isEnableSaveButton()
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
                isEnableSaveButton()
            }
        }

        @objc func emailAdressEditingDidEnd() {
            if emailErrorIcon.isHidden == true && emailErrorLabel.isHidden == true {
                emailTextField.layer.borderColor = UIColor.color(.BorderColor).cgColor
            } else {
                emailTextField.layer.borderColor = UIColor.color(.Red).cgColor
            }
        }
    
    func isEnableSaveButton() {
        if nameErrorIcon.isHidden == true && nameErrorLabel.isHidden == true && emailErrorIcon.isHidden == true && emailErrorLabel.isHidden == true && emailTextField.text!.count > 0{
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
