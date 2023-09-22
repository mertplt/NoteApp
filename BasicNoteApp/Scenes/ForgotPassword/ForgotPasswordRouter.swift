//
//  ForgotPasswordRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit
import ToastViewSwift

protocol ForgotPasswordRouterDelegate: AnyObject {
    func navigateToLogin()
    }

final class ForgotPasswordRouter: ForgotPasswordRouterDelegate {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Navigation methods

    func navigateToLogin() {
        let loginViewController = LoginViewController()
        viewController?.navigationController?.show(loginViewController, sender: nil)
    }
    
    func showResetPasswordSuccess(email: String) {
        let toast = Toast.default(
            image: UIImage(named: "ic_success")!,
            title: "An email has been sent to",
            subtitle: "\(email) with further instructions."
        )
        toast.show()
    }
    
    func showResetPasswordError(errorMessage: String) {
        let toast = Toast.default(
            image: UIImage(named: "ic_error64x64")!,
            title: "The email you entered did not match",
            subtitle: "Please try again"
        )
        toast.show()
    }
}

