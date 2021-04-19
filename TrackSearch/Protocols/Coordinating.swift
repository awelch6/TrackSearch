//
//  Coordinating.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import UIKit

protocol Coordinating {

    var childCoordinators: [Coordinating] { get set }

    var navigationController: UINavigationController { get }
        
    func start()
}
