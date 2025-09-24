//
//  AppDelegate.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = PortfolioViewController()
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

