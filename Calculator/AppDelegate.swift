//
//  AppDelegate.swift
//  Calculator
//
//  Created by out-nazarov2-ms on 13.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        window.rootViewController = CalculatorAssembly.createModule()
        self.window = window 
        return true
    }

}

