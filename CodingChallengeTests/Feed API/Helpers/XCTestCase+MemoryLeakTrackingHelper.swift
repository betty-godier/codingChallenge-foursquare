//
//      2022  Betty Godier
//      Coding challenge
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file , line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potentiel memory leak.", file: file, line: line)
        }
    }
}
