//
//  NotesRouter.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.08.2023.
//

import UIKit

class NotesRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Navigation methods

    func navigateToAddNote() {
        let addAndEditNoteViewController = AddAndEditNoteViewController()
        viewController?.navigationController?.show(addAndEditNoteViewController, sender: nil)
        addAndEditNoteViewController.isAdd = true
    }
    
    func navigateToEditNote(noteID: Int, noteText: String, noteTitle: String) {
 
        let editNoteViewController = AddAndEditNoteViewController()
        editNoteViewController.isAdd = false
        editNoteViewController.noteID = noteID
        editNoteViewController.noteText = noteText
        editNoteViewController.noteTitle = noteTitle
        viewController?.navigationController?.pushViewController(editNoteViewController, animated: true)
    }

    func navigateToProfile(){
        let profileViewController = ProfileViewController()
        viewController?.navigationController?.show(profileViewController, sender: nil)
    }
}

