//
//  ForgotPasswordViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.08.2023.
//

import Foundation

protocol ForgotPasswordViewModelDelegate: AnyObject {
    // MARK: - Delegate Methods

    func resetPasswordSuccess()
    func resetPasswordFailure(errorMessage: String)
}

class ForgotPasswordViewModel {
    // MARK: - Properties

    weak var delegate: ForgotPasswordViewModelDelegate?
    
    // MARK: - Methods

    func resetPassword(email: String) {
        if !Validation().validateEmail(email: email) {
            delegate?.resetPasswordFailure(errorMessage: "Invalid email format. Please check your input.")
            return
        }
        
        let forgotPasswordModel = ForgotPasswordModel(email: email)
        APIManager.shareInstance.callingForgotPasswordAPI(forgotPassword: forgotPasswordModel) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.resetPasswordSuccess()
            case .failure:
                self?.delegate?.resetPasswordFailure(errorMessage: "Reset password failed. Please try again.")
            }
        }
    }
}

