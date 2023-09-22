//
//  LoginRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit
import ToastViewSwift

protocol LoginRouterDelegate: AnyObject {
    func navigateToSignUp()
    func navigateToForgotPassword()
    func navigateToNotes()
}

final class LoginRouter: LoginRouterDelegate {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Navigation methods

    func navigateToForgotPassword() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        viewController?.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    func navigateToSignUp() {
        let registerViewController = RegisterViewController()
        viewController?.navigationController?.show(registerViewController, sender: nil)

    }
    
    func navigateToNotes() {
        let notesViewController = NotesViewController()
        viewController?.navigationController?.show(notesViewController, sender: nil)
        showLoginError(errorMessage: "User login Successfully")

    }
    
    func showLoginError(errorMessage: String) {
        
        let label = UILabel()
        label.text = errorMessage
        label.numberOfLines = 0
        
        let toastView = AppleToastView(child: label)
        let toast = Toast.custom(view: toastView)
        toast.show()
    }
}
