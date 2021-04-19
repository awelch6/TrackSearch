//
//  TrackResponse.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/16/21.
//

import Foundation
import Alamofire
import RxAlamofire

struct TrackResponse: Decodable {
    let resultCount: Int
    let results: [Result]
    
    init(resultCount: Int, results: [Result]) {
        self.resultCount = resultCount
        self.results = results
    }
}

extension TrackResponse {
    
    struct Result: Decodable {
        
        let artistName: String?
        let trackName: String?
        let trackPrice: Double?
        let releaseDate: Date?
        let primaryGenreName: String?
        
        enum CodingKeys: String, CodingKey {
            case artistName
            case trackName
            case trackPrice
            case releaseDate
            case primaryGenreName
        }

        init(artistName: String, trackName: String, trackPrice: Double, releaseDate: Date, primaryGenreName: String) {
            self.artistName = artistName
            self.trackName = trackName
            self.trackPrice = trackPrice
            self.releaseDate = releaseDate
            self.primaryGenreName = primaryGenreName
        }
    }
}
