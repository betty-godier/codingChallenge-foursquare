//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

protocol HTTPClient {
    func perform(request url: URLRequest)
}
