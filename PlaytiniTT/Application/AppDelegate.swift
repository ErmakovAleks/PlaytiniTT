//
//  AppDelegate.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 21.01.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        self.mainCoordinator = MainCoordinator(navigationController: navigationController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

