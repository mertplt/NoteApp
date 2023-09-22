//
//  SplashViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 9.08.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            let notesViewController = NotesViewController()
            navigationController?.pushViewController(notesViewController, animated: true)
        } else {
            let registerViewController = RegisterViewController()
            navigationController?.pushViewController(registerViewController, animated: true)
        }
    }
}
