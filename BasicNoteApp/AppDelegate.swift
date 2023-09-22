//
//  AppDelegate.swift
//  BasicNoteApp
//
//  Created by mert polat on 11.07.2023.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        let SplashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: SplashViewController)
        window?.rootViewController = navigationController
        
        return true
    }
}
