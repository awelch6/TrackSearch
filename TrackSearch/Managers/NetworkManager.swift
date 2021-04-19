//
//  NetworkManager.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/18/21.
//

import Foundation
import RxAlamofire
import RxSwift
import Alamofire

protocol TrackSearchable {
    
    /// fires when there is an outgoing `searchArtists` request
    var isFetching: Observable<Bool> { get }
    
    /// Searches for a given Artist/track based on the search term provided
    func searchArtist(term: String) -> Observable<TrackResponse>
}

enum NetworkError: Error {
    case noData
}

class NetworkManager {
    
    private let _isFetching = ReplaySubject<Bool>.create(bufferSize: 1)
    
    private let baseURLString: String = "https://itunes.apple.com/search"
    
    private let sessionManager: Session
        
    public init(sessionManager: Session = Session.default) {
        self.sessionManager = sessionManager
    }
}


// MARK: TrackSearchable

extension NetworkManager: TrackSearchable {
    
    var isFetching: Observable<Bool> {
        return _isFetching
    }
    
    func searchArtist(term: String) -> Observable<TrackResponse> {
        _isFetching.onNext(true)
        
        let parameters: [String: Any] = [
            "term": term
        ]
        
        return sessionManager.rx
            .request(.get, baseURLString, parameters: parameters)
            .responseJSON()
            .do(onNext: { [weak self] _ in self?._isFetching.onNext(false) })
            .flatMap { response -> Observable<TrackResponse> in
  
                guard let data = response.data else {
                    return .error(NetworkError.noData)
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let response = try decoder.decode(TrackResponse.self, from: data)
                    
                    return .just(response)
                } catch let error {
                    return .error(error)
                }
            }
    }
}
