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
        
        sut.get(from: request)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    // MARK: -Helpers
    
    private class URLSessionSpy: URLSession {
        private var stubs = [URLRequest: URLSessionDataTask]()
        
        func stub(request: URLRequest, task: URLSessionDataTask) {
            stubs[request] = task
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return stubs[request] ?? FakeURLSessionDataTask()
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
