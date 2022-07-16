//
//      2022  Betty.dev 
//

import XCTest
@testable import CodingChallenge

class URLSessionHTTPClientTests: XCTest {
    
    func test_getFromURLRequest_createDataTaskWithURLRequest() {
        let request = URLRequest(url: URL(string: "http://any-url.com")!)
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPCLient(session: session)
        sut.get(from: request)
        
        XCTAssertEqual(session.requestedRequests, [request])
    }
    
    // MARK: -Helpers
    
    private class URLSessionSpy: URLSession {
        var requestedRequests = [URLRequest]()
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            requestedRequests.append(request)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
