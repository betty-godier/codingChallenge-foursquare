//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_performsGETRequestWithURL() {
        URLProtocolStub.startInterceptingRequest()
        let url = URL(string: "http://any-url.com")!
        let request = URLRequest(url: url)
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        URLSessionHTTPCLient().get(from: request) { _ in }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURLRequest_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequest()
        let url = URL(string: "http://any-url.com")!
        let request = URLRequest(url: url)
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPCLient()
        
        sut.get(from: request) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertNotNil(receivedError)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
        }
        URLProtocolStub.stopInterceptingRequest()
    }
    
    // MARK: -Helpers
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver!(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        override func stopLoading() {}
    }
}
