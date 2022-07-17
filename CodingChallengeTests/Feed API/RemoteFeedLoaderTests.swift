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
        
        sut.load(radius: "") { _ in }
        
        XCTAssertNotNil(client.requestedRequests)
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URLRequest(url: URL(string: "https://a-given.com")!)
        let (sut, client) = makeSUT(url: url)
        
        sut.load(radius: "") { _ in }
        sut.load(radius: "") { _ in }
        
        XCTAssertEqual(client.requestedRequests.count , 2)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
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
    
//    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
//        let (sut, client) = makeSUT()
//
//        let item1 = FeedItem(name: "a name", address: nil, city: nil, categoryName: "a category name", distance: nil)
//
//        let item1Json = [
//            "name": item1.name,
//            "categories": [
//                "name": item1.categoryName
//                ]
//        ] as [String : Any]
//
//        let item2 = FeedItem(name: "another name", address: "an address", city: "a city", categoryName: "a category name", distance: 5000)
//
//        let item2Json = [
//            "name": item2.name,
//            "categories": [
//                "name": item2.categoryName
//            ],
//            "distance": item2.distance ?? 0,
//            "location": [
//                "address": item2.address,
//                "locality": item2.city
//            ]
//        ] as [String : Any]
//
//        let itemsJson = [
//            "results": [item1Json, item2Json]
//        ]
//        print(itemsJson)
//        expect(sut, toCompleteWith: .success([item1, item2])) {
//            let json = try! JSONSerialization.data(withJSONObject: itemsJson)
//            client.complete(withStatusCode: 200, data: json)
//        }
//    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URLRequest(url: URL(string: "https://a-url.com")!)
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load(radius: "") { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URLRequest = URLRequest(url: URL(string: "https://a-url.com")!), file: StaticString = #file , line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, name: String, address: String? = nil, city: String? = nil, categoryName: String? = nil, distance: Int? = nil) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(name: name, address: address, city: city, categoryName: categoryName, distance: distance)
        
        let json = [
            "id": id.uuidString,
            "name": name,
            "address": address ?? "",
            "city": city ?? "",
            "categoryName": categoryName ?? "",
            "distance": distance ?? 0
        ] as [String : Any]
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]])-> Data {
        let json = ["results": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(radius: "") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URLRequest, completion: (HTTPClientResult) -> Void)]()
        
        var requestedRequests: [URLRequest] {
            return messages.map { $0.url }
        }
        
        func sendRequest(endpoint: Endpoint, completion: @escaping (HTTPClientResult) -> Void) {
            var urlComponents = URLComponents()
            urlComponents.scheme = endpoint.scheme
            urlComponents.host = endpoint.host
            urlComponents.path = endpoint.path
            urlComponents.queryItems = endpoint.queryItems
        
            guard let url = urlComponents.url else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method
            request.allHTTPHeaderFields = endpoint.headers
            messages.append((request, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedRequests[index].url!,
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
}

