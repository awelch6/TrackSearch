//
//  SearchView.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/16/21.
//

import Foundation
import UIKit

class SearchView: UIView, Contentable {
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self)
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    func render() {
        setProperties()
        setTableView()
    }
}

// MARK: UI Setup

extension SearchView {
    
    private func setProperties() {
        backgroundColor = .white
    }
    
    private func setTableView() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
