//
//  SearchViewModel.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelProtocol {
    
    struct Input {
        let searchText: AnyObserver<String?>
    }
    
    struct Output {
        let isFetching: Observable<Bool>
        let dataSource: Observable<[SearchCellViewModel]>
    }
    
    // Input
    private let searchText = PublishSubject<String?>()
    
    // Output
    private let dataSource = ReplaySubject<[SearchCellViewModel]>.create(bufferSize: 1)
    
    let input: Input
    let output: Output
    
    private let bag = DisposeBag()
    
    public init(trackSearchable: TrackSearchable) {
        self.input = Input(searchText: searchText.asObserver())
        self.output = Output(isFetching: trackSearchable.isFetching, dataSource: dataSource)
        
        searchText
            .ignoreNil()
            .flatMap({ searchText -> Observable<[SearchCellViewModel]> in
                return trackSearchable.searchArtist(term: searchText)
                    .map({ $0.results.map({ SearchCellViewModel(result: $0) }) })
                    .catchErrorJustReturn([])
            }).catchErrorJustReturn([])
            .bind(to: dataSource)
            .disposed(by: bag)
    }
}
