//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDatafromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URLRequest = URLRequest(url: URL(string: "https://a-url.com")!)) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URLRequest?
        
        func get(from url: URLRequest) {
            requestedURL = url
        }
    }
}

