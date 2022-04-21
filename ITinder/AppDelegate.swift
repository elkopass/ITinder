//
//  AppDelegate.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit



@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        let homeVC = StartScreen()
        navController.pushViewController(homeVC, animated: false)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        navController.navigationBar.tintColor = UIColor(named: "PinkColor")
        
        return true
    }

    // MARK: UISceneSession Lifecycle




}

