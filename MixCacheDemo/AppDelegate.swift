//
//  AppDelegate.swift
//  MixCacheDemo
//
//  Created by Eric Long on 2021/9/15.
//  Copyright © 2021 Eric Lung. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let nav = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = nav
        return true
    }
}

