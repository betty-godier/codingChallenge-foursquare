//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URLRequest(url: URL(string: "https://a-url.com")!))
    }
}
