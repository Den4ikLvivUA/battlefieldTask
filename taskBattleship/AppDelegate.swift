//
//  AppDelegate.swift
//  taskBattleship
//
//  Created by MacBook on 6/1/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "vc")
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

