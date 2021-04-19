//
//  SearchCoordinator.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import UIKit

class SearchCoordinator: Coordinating {
    
    /// Holds references to the children flow coordinators so that they are not deallocated
    var childCoordinators: [Coordinating] = []
    
    let navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController.create(with: SearchViewModel(trackSearchable: NetworkManager()))
        navigationController.pushViewController(searchViewController, animated: true)
    }
}
