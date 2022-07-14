//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URLRequest
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URLRequest, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
