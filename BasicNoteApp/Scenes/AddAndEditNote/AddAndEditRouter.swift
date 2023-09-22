//
//  AddAndEditRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit

class AddAndEditNoteRouter {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Navigation methods

    func navigateBack() {        
        let notesViewController = NotesViewController()
        viewController?.navigationController?.show(notesViewController, sender: nil)
    }
}
