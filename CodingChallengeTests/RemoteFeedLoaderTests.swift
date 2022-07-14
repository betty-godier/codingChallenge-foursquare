//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDatafromURL() {
        let client = HTTPClientSpy()
        _ = makeSUT(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let client = HTTPClientSpy()
        let sut = makeSUT(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    private func makeSUT(url: URLRequest = URLRequest(url: URL(string: "https://a-url.com")!), client: HTTPClientSpy) -> RemoteFeedLoader {
        let client = HTTPClientSpy()
        return RemoteFeedLoader(url: url, client: client)
    }
}

class HTTPClientSpy: HTTPClient {
    func perform(request url: URLRequest) {
        requestedURL = url
    }
    
    var requestedURL: URLRequest?
}
