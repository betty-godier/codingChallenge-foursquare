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
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data("{\"results\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = FeedItem(
            id: UUID(),
            name: "a name",
            address: nil,
            city: nil,
            categoryName: nil,
            distance: nil
            )

        let item1JSON = [
            "id": item1.id.uuidString,
            "name": item1.name
        ]

        let item2 = FeedItem(
            id: UUID(),
            name: "a name",
            address: "an address",
            city: "a city",
            categoryName: "a category name",
            distance: 400
            )

        let item2JSON = [
            "id": item2.id.uuidString,
            "name": item2.name,
            "address": item2.address!,
            "city": item2.city!,
            "categoryName": item2.categoryName!,
            "distance":  item2.distance!
        ] as [String : Any]

        let itemsJSON = [
            "results": [item1JSON, item2JSON]
        ]

        expect(sut, toCompleteWith: .success([item1, item2]), when: {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URLRequest = URLRequest(url: URL(string: "https://a-url.com")!)) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
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
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedRequests[index].url!,
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
}

