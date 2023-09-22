//
//  RegisterRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit

protocol RegisterRouterDelegate: AnyObject {
    func navigateToLogin()
    func navigateToForgotPassword()
    func navigateToNotes()
}

final class RegisterRouter: RegisterRouterDelegate {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Navigation methods

    func navigateToLogin() {
        let loginViewController = LoginViewController()
        viewController?.navigationController?.pushViewController(loginViewController, animated: true)
    }

    func navigateToForgotPassword() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        viewController?.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }

    func navigateToNotes() {
        let notesViewController = NotesViewController()
        viewController?.navigationController?.show(notesViewController, sender: nil)
    }
}
