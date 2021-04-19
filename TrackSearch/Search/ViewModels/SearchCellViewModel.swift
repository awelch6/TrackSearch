//
//  SearchCellViewModel.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/16/21.
//

import Foundation
import RxSwift

class SearchCellViewModel: ViewModelProtocol {
    
    struct Input { }
    
    struct Output {
        let artistText: Observable<String?>
        let trackNameText: Observable<String?>
        let releaseDateText: Observable<String?>
        let genreText: Observable<String?>
        let priceText: Observable<String?>
    }
    
    let input: Input
    let output: Output
    
    // Output
    private let artistText = ReplaySubject<String?>.create(bufferSize: 1)
    private let trackNameText = ReplaySubject<String?>.create(bufferSize: 1)
    private let releaseDateText = ReplaySubject<String?>.create(bufferSize: 1)
    private let genreText = ReplaySubject<String?>.create(bufferSize: 1)
    private let priceText = ReplaySubject<String?>.create(bufferSize: 1)
    
    private let result: TrackResponse.Result
    
    init(result: TrackResponse.Result) {
        self.result = result
        
        self.input = Input()
        self.output = Output(artistText: artistText, trackNameText: trackNameText,
                             releaseDateText: releaseDateText, genreText: genreText, priceText: priceText)
        
        
        artistText.onNext(result.artistName)
        trackNameText.onNext(result.trackName)
        releaseDateText.onNext(formattedReleaseDate(date: result.releaseDate))
        genreText.onNext(result.primaryGenreName)
        priceText.onNext(result.trackPrice.flatMap({ "$\(String($0))" }))
    }
    
    private func formattedReleaseDate(date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return "Released: \(formatter.string(from: date))"
    }
}
