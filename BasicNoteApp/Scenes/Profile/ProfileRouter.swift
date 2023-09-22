//
//  ProfileRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit

class ProfileRouter {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Navigation methods

    func navigateToChangePassword() {
        let changePasswordViewController = ChangePasswordViewController()
        viewController?.navigationController?.show(changePasswordViewController, sender: nil)
    }

    func navigateToNotes() {
        let notesViewController = NotesViewController()
        viewController?.navigationController?.show(notesViewController, sender: nil)
    }

    func navigateToRegister() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
         
        let registerViewController = RegisterViewController()
        viewController?.navigationController?.show(registerViewController, sender: nil)
    }

}
