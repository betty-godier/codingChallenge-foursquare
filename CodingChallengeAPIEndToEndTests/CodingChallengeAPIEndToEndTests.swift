//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest
@testable import CodingChallenge

class CodingChallengeAPIEndToEndTests: XCTestCase {

    func test_endToEndTestsServerGETURLRequest_fromURL() {
        let testServerULR = URLRequest(url: URL(string: "https://api.foursquare.com/v3/places/search")!)
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: testServerULR, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: LoadFeedResult?
        loader.load(radius: "") { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(items)?:
            XCTAssertEqual(items.count, 10, "Expected 10 items in the test account")
        case let .failure(error)?:
            XCTFail("Expectd successful feed result, got \(error) instead.")
        default:
            XCTFail("Expected successful feed result, got no result instead.")
        }
    }
}
