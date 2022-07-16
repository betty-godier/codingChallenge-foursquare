//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class URLSessionHTTPClientTests: XCTest {
    
    func test_getFromURLRequest_resumesDataTaskWithURLRequest() {
        let request = URLRequest(url: URL(string: "http://any-url.com")!)
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(request: request, task: task)
        
        let sut = URLSessionHTTPCLient(session: session)
        
        sut.get(from: request) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURLRequest_failsOnRequestError() {
        let request = URLRequest(url: URL(string: "http://any-url.com")!)
        let error = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy()
        session.stub(request: request, error: error)
        
        let sut = URLSessionHTTPCLient(session: session)
                
        sut.get(from: request) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertNotNil(receivedError)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
        }
    }
    
    // MARK: -Helpers
    
    private class URLSessionSpy: URLSession {
        private var stubs = [URLRequest: Stub]()
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }

        func stub(request: URLRequest, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[request] = Stub(task: task, error: error)
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[request] else {
                fatalError("Couldn't find stub for \(request)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }

}
