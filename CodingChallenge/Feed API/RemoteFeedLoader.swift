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
        case invalidData
    }
    
    public init(url: URLRequest, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        }
    }
}
