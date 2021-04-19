//
//  NetworkManagerTests.swift
//  TrackSearchTests
//
//  Created by Austin Welch on 4/18/21.
//

import Quick
import Nimble
import RxAlamofire
import Alamofire
import RxSwift
import RxTest

@testable import TrackSearch

class NetworkManagerTests: QuickSpec {
    
    override func spec() {
        
        var networkManager: NetworkManager!
        var sessionManager: Session!
        
        let scheduler = TestScheduler(initialClock: 0)
        let bag = DisposeBag()
        
        beforeEach {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            
            sessionManager = Session(configuration: configuration)
            
            networkManager = NetworkManager(sessionManager: sessionManager)
        }
        
        it("should return a successful response when the request is successful") {
            let response = HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = readJSONFromFile(fileName: "TrackResponse")
            MockURLProtocol.responseType = .success(response, data)
                        
            let responseObservable = scheduler.createObserver(TrackResponse.self)
            
            networkManager.searchArtist(term: "term")
                .bind(to: responseObservable)
                .disposed(by: bag)
                        
            expect(responseObservable.events.count).toEventually(equal(2))
            expect(responseObservable.events[0].value.element).to(beAKindOf(TrackResponse.self))
        }
        
        it("should update the isFetching property when making a successful request") {
            let response = HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = readJSONFromFile(fileName: "TrackResponse")
            MockURLProtocol.responseType = .success(response, data)
                        
            let isFetchingObservable = scheduler.createObserver(Bool.self)
            
            networkManager.isFetching
                .bind(to: isFetchingObservable)
                .disposed(by: bag)
                        
            networkManager.searchArtist(term: "term").subscribe().disposed(by: bag)
            
            expect(isFetchingObservable.events.count).toEventually(equal(2))
            expect(isFetchingObservable.events.map({ $0.value.element })).to(equal([true, false]))
        }
        
        it("should return an error if there is an error in the request") {
            MockURLProtocol.responseType = .error(NSError(domain: "www", code: 404, userInfo: nil))
                        
            let responseObservable = scheduler.createObserver(TrackResponse.self)
            
            networkManager.searchArtist(term: "term")
                .bind(to: responseObservable)
                .disposed(by: bag)
                        
            expect(responseObservable.events.count).toEventually(equal(1))
            expect(responseObservable.events[0].value.error).toNot(beNil())
        }
    }
}

private func readJSONFromFile(fileName: String) -> Data {
    
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
        preconditionFailure("Unable to find file named: \(fileName).json")
    }
    
    return data
}
