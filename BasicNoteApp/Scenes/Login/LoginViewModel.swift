//
//  LoginViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.08.2023.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    // MARK: - Delegate Methods

    func loginSuccess()
    func loginFailure(errorMessage: String)
}

class LoginViewModel {
    // MARK: - Properties

    weak var delegate: LoginViewModelDelegate?
    
    // MARK: - Methods

    func loginUser(email: String, password: String) {
        if !validateInputs(email: email, password: password) {
            delegate?.loginFailure(errorMessage: "Invalid email or password. Please check your input.")
            return
        }
        
        let loginModel = LoginModel(email: email, password: password)
        
        APIManager.shareInstance.callingLoginAPI(login: loginModel) { [weak self] isSuccess in
            if isSuccess {
                self?.delegate?.loginSuccess()
            } else {
                self?.delegate?.loginFailure(errorMessage: "Login failed. Please check your credentials and try again.")
            }
        }
    }
    
    private func validateInputs(email: String, password: String) -> Bool {
        return Validation().validateEmail(email: email) && Validation().validatePassword(password: password)
    }
}

