//
//  AppDelegate.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: window!)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator.start()
        return true
    }
}
