//
//  RegisterViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 12.07.2023.
//

import Foundation

protocol RegisterViewModelDelegate: AnyObject {
    // MARK: - Delegate Methods

    func registrationSuccess()
    func registrationFailure(errorMessage: String)
}

class RegisterViewModel {
    // MARK: - Properties

     var delegate: RegisterViewModelDelegate?
    
    // MARK: - Methods

    func registerUser(name: String, email: String, password: String) {
        if !validateInputs(name: name, email: email, password: password) {
            delegate?.registrationFailure(errorMessage: "Invalid input. Please check the fields.")
            return
        }
        
        let register = RegisterModel(full_name: name, email: email, password: password)
        
        APIManager.shareInstance.callingRegisterAPI(register: register) { [weak self] isSuccess in
            if isSuccess {
                self?.delegate?.registrationSuccess()
            } else {
                self?.delegate?.registrationFailure(errorMessage: "User Registration Failed. Please try again")
            }
        }
    }
    
    private func validateInputs(name: String, email: String, password: String) -> Bool {
        return Validation().validateName(name: name) &&
               Validation().validateEmail(email: email) &&
               Validation().validatePassword(password: password)
    }
}

