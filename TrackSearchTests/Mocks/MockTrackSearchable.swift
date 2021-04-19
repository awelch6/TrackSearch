//
//  MockTrackSearchable.swift
//  TrackSearchTests
//
//  Created by Austin Welch on 4/18/21.
//

import RxSwift
import RxCocoa

@testable import TrackSearch

class MockTrackSearchable: TrackSearchable {
    
    var isFetchingResult = BehaviorRelay<Bool>(value: false)
    
    var searchArtistWasCalled = 0
    var searchArtistWasCalledWith: String?
    var searchArtistResult: Observable<TrackResponse> = .just(TrackResponse(resultCount: 0, results: []))
    
    var shouldFailWithError: Error?
    
    var isFetching: Observable<Bool> {
        return isFetchingResult.asObservable()
    }
    
    func searchArtist(term: String) -> Observable<TrackResponse> {
        searchArtistWasCalled += 1
        searchArtistWasCalledWith = term
        
        if let error = shouldFailWithError {
            return .error(error)
        }
        
        return searchArtistResult
    }
    
    
}
