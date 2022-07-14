//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    func load() {
        client.get(from: URLRequest(url: URL(string: "https://a-url.com")!))
    }
}
