//
//      2022  Betty Godier
//      Coding challenge
//

import SwiftUI
import XCTest
@testable import CodingChallenge


class PlaceListViewModelTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURLRequest() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
