//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDatafromURL() {
        let client = HTTPClientSpy()
        
        _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

class HTTPClientSpy: HTTPClient {
    func get(from url: URLRequest) {
        requestedURL = url
    }
    
    var requestedURL: URLRequest?
}
