//
//  UITableViewExtensions.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/16/21.
//

import Foundation
import UIKit

public protocol Reusable: class { }

extension Reusable where Self: UIView {

    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: UITableView

extension UITableViewCell: Reusable { }

extension UITableView {

    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Unable to dequeue cell!")
        }

        return cell
    }
}
