//
//  SearchViewController.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
       
    private let viewModel: ViewModelType
    private let bag = DisposeBag()
    
    public init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Artists"
        
        contentView.render()
        configure(with: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        definesPresentationContext = true
        navigationItem.searchController = contentView.searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.activityIndicator)
    }
}

// MARK: ContentView

extension SearchViewController: ContentView {
    
    typealias ContentView = SearchView
    
}

// MARK: ControllerType

extension SearchViewController: ControllerType {
    
    typealias ViewModelType = SearchViewModel
    
    func configure(with viewModel: SearchViewModel) {
        contentView.tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        contentView.searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(contentView.searchController.searchBar.rx.text)
            .bind(to: viewModel.input.searchText)
            .disposed(by: bag)
        
        contentView.searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.contentView.searchController.isActive = false
            }).disposed(by: bag)
        
        viewModel.output.isFetching
            .bind(to: contentView.activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.output.dataSource
            .bind(to: contentView.tableView.rx.items(cellIdentifier: SearchTableViewCell.defaultReuseIdentifier, cellType: SearchTableViewCell.self)) { _, viewModel, cell in
                cell.set(viewModel)
        }.disposed(by: bag)
    }
    
    static func create(with viewModel: SearchViewModel) -> UIViewController {
        return SearchViewController(viewModel: viewModel)
    }
}

// MARK: UIScrollViewDelegate

extension SearchViewController: UIScrollViewDelegate { }
