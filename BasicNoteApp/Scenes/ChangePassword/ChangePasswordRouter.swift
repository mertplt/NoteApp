//
//  ChangePasswordRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit

class ChangePasswordRouter {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Navigation methods

    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
