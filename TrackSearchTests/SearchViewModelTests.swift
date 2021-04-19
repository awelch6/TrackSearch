//
//  SearchViewModelTests.swift
//  TrackSearchTests
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import Quick
import Nimble
import RxTest
import RxSwift

@testable import TrackSearch

class SearchViewModelTests: QuickSpec {
    
    override func spec() {
        
        var mockTrackSearchable: MockTrackSearchable!
        var scheduler = TestScheduler(initialClock: 0)
        var viewModel: SearchViewModel!
        
        let bag = DisposeBag()
        
        beforeEach {
            mockTrackSearchable = MockTrackSearchable()
            
            viewModel = SearchViewModel(trackSearchable: mockTrackSearchable)
        }
        
        it("should update the isFetching property properly") {
            let isFetchingObservable = scheduler.createObserver(Bool.self)

            viewModel.output.isFetching
                .bind(to: isFetchingObservable)
                .disposed(by: bag)
            
            // simulate a search happening, initial value is already false
            mockTrackSearchable.isFetchingResult.accept(true)
            mockTrackSearchable.isFetchingResult.accept(false)
            
            expect(isFetchingObservable.events.map({ $0.value.element })).to(equal([false, true, false])) // initial value is false
        }
        
        it("should make a request to search artists if there is searchText and update the dataSource") {
            let result = TrackResponse.Result(artistName: "", trackName: "", trackPrice: 1.0, releaseDate: Date(), primaryGenreName: "")
            
            mockTrackSearchable.searchArtistResult = .just(TrackResponse(resultCount: 2, results: [result, result]))
            
            let dataSourceObservable = scheduler.createObserver([SearchCellViewModel].self)

            viewModel.output.dataSource
                .bind(to: dataSourceObservable)
                .disposed(by: bag)
            
            
            viewModel.input.searchText.onNext("SearchText")
            
            // make sure that NetworkManager gets called correctly
            expect(mockTrackSearchable.searchArtistWasCalled).to(equal(1))
            expect(mockTrackSearchable.searchArtistWasCalledWith).to(equal("SearchText"))
            
            expect(dataSourceObservable.events.count).to(equal(1)) // one for the inital value
            expect(dataSourceObservable.events[0].value.element?.count).to(equal(2)) // check that we created 2 SearchCellViewModels
        }
        
        it("should not make a request to search for artists if there is no search text") {
            viewModel.input.searchText.onNext(nil)
            
            expect(mockTrackSearchable.searchArtistWasCalled).to(equal(0))
        }
        
        it("should update the datasource with an empty array if any error occurs when requesting artists") {
            mockTrackSearchable.shouldFailWithError = NSError(domain: "123", code: 404, userInfo: nil)
            
            let dataSourceObservable = scheduler.createObserver([SearchCellViewModel].self)

            viewModel.output.dataSource
                .bind(to: dataSourceObservable)
                .disposed(by: bag)
            
            
            viewModel.input.searchText.onNext("SearchText")
            
            // make sure that NetworkManager gets called correctly
            expect(mockTrackSearchable.searchArtistWasCalled).to(equal(1))
            expect(mockTrackSearchable.searchArtistWasCalledWith).to(equal("SearchText"))
            
            expect(dataSourceObservable.events.count).to(equal(1)) // one for the inital value
            expect(dataSourceObservable.events[0].value.element).to(beEmpty()) // check that we returned an empty array
        }
    }
}
