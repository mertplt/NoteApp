//
//  ChangePasswordViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 15.08.2023.
//

import Foundation

class ChangePasswordViewModel {
    
    // MARK: - Properties

    var currentPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    // MARK: - Computed Properties

    var isSaveButtonEnabled: Bool {
        return isPasswordValid && isNewPasswordValid && isConfirmPasswordValid
    }
    
    var isPasswordValid: Bool {
        return Validation().validatePassword(password: currentPassword)
    }
    
    var isNewPasswordValid: Bool {
        return Validation().validatePassword(password: newPassword)
    }
    
    var isConfirmPasswordValid: Bool {
        return newPassword == confirmPassword
    }
    // MARK: - Methods

    func changePassword(completion: @escaping (Bool) -> Void) {
        let changePasswordModel = changePasswordModel(
            password: currentPassword,
            new_password: newPassword,
            new_password_confirmation: confirmPassword
        )
        
        APIManager.shareInstance.callingChangePasswordAPI(changePassword: changePasswordModel) { isSuccess in
            completion(isSuccess)
        }
    }
}
