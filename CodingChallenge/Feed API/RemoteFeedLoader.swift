//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URLRequest
    
    init(url: URLRequest, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    func load() {
        client.get(from: url)
    }
}
