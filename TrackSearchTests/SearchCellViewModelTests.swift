//
//  SearchCellViewModelTests.swift
//  TrackSearchTests
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

@testable import TrackSearch

class SearchCellViewModelTests: QuickSpec {
    
    override func spec() {
        
        let scheduler = TestScheduler(initialClock: 0)
        var viewModel: SearchCellViewModel!
        
        let date = Date(timeIntervalSinceReferenceDate: 536500800)
        let result = TrackResponse.Result(artistName: "artist", trackName: "track", trackPrice: 0.99, releaseDate: date, primaryGenreName: "pop")
        
        let bag = DisposeBag()
        
        beforeEach {
            
            viewModel = SearchCellViewModel(result: result)
        }
        
        it("should have the correctly formatted artistNameText") {
            let artistNameObservable = scheduler.createObserver(String?.self)
            
            viewModel.output.artistText
                .bind(to: artistNameObservable)
                .disposed(by: bag)
            
            expect(artistNameObservable.events.count).to(equal(1))
            expect(artistNameObservable.events[0].value.element).to(equal("artist"))
        }
        
        it("should have the correctly formatted trackNameText") {
            let trackNameObservable = scheduler.createObserver(String?.self)
            
            viewModel.output.trackNameText
                .bind(to: trackNameObservable)
                .disposed(by: bag)
            
            expect(trackNameObservable.events.count).to(equal(1))
            expect(trackNameObservable.events[0].value.element).to(equal("track"))
        }
        
        it("should have the correctly formatted releaseDateText") {
            let releaseDateTextObservable = scheduler.createObserver(String?.self)
            
            viewModel.output.releaseDateText
                .bind(to: releaseDateTextObservable)
                .disposed(by: bag)
            
            expect(releaseDateTextObservable.events.count).to(equal(1))
            expect(releaseDateTextObservable.events[0].value.element).to(equal("Released: April 19, 2021"))
        }
        
        it("should have the correctly formatted genreText") {
            let genreTextObservable = scheduler.createObserver(String?.self)
            
            viewModel.output.genreText
                .bind(to: genreTextObservable)
                .disposed(by: bag)
            
            expect(genreTextObservable.events.count).to(equal(1))
            expect(genreTextObservable.events[0].value.element).to(equal("pop"))
        }
        
        it("should have the correctly formatted priceText") {
            let priceTextObservable = scheduler.createObserver(String?.self)
            
            viewModel.output.priceText
                .bind(to: priceTextObservable)
                .disposed(by: bag)
            
            expect(priceTextObservable.events.count).to(equal(1))
            expect(priceTextObservable.events[0].value.element).to(equal("$0.99"))
        }
    }
}
