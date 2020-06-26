//
//  AppDelegate.swift
//  OneEye
//
//  Created by Georges on 31/05/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UITabBar.appearance().barTintColor = .blue
//        UITabBar.appearance().tintColor = .white
        
        FirebaseApp.configure()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        let blue = UIColor(red: 33/255.0, green: 100/255.0, blue: 171/255.0, alpha: 1)
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.barTintColor = blue
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .white
        tabBarAppearance.barTintColor = blue
        
        let TableAppearance = UITableView.appearance()
        TableAppearance.separatorColor = .white
        TableAppearance.backgroundColor = .white
        
        let cellTableAppearance = UITableViewCell.appearance()
        cellTableAppearance.backgroundColor = UIColor(red: 16/255.0, green: 50/255.0, blue: 86/255.0, alpha: 1)
        cellTableAppearance.tintColor = .white
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

