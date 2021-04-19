//
//  AppCoordinator.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import UIKit

class AppCoordinator: Coordinating {
    
    /// Holds references to the children flow coordinators so that they are not deallocated
    var childCoordinators: [Coordinating] = []
    
    var navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let coordinator = SearchCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
