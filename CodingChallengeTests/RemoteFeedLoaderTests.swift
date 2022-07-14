//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDatafromURL() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
}

class HTTPClientSpy: HTTPClient {
    func get(from url: URLRequest) {
        requestedURL = url
    }
    
    var requestedURL: URLRequest?
}
