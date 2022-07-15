//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDatafromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedRequests.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedRequests, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedRequests , [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { capturedErrors.append($0) }
            
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedErrors, [.invalidData])
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URLRequest = URLRequest(url: URL(string: "https://a-url.com")!)) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URLRequest, completion: (HTTPClientResult) -> Void)]()

        var requestedRequests: [URLRequest] {
            return messages.map { $0.url }
        }
        
        func get(from url: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedRequests[index].url!,
                                statusCode: code,
                                httpVersion: nil,
                                headerFields: nil
            )!
            messages[index].completion(.success(response))
        }
    }
}

