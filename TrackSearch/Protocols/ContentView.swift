//
//  ContentView.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import UIKit

public protocol Contentable: UIView {
    
    /// call this method from the parent view when you are ready for this view to be laid out.
    func render()
}

extension Contentable where Self: ContentView { }

public protocol ContentView {
    
    associatedtype ContentView: Contentable

}

extension ContentView where Self: UIViewController {
    
    /// The UIViewController's custom view.
    public var contentView: ContentView {
        guard let contentView = view as? ContentView else {
            fatalError("Expected view to be of type \(ContentView.self) but got \(type(of: view)) instead")
        }
        return contentView
    }
}
