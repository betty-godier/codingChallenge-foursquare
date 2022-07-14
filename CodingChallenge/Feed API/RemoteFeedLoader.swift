//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URLRequest
    private let client: HTTPClient
    
    public init(url: URLRequest, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load() {
        client.get(from: url)
    }
}
