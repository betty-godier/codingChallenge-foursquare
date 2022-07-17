//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URLRequest
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URLRequest, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Result) -> Void) {
        client.sendRequest(endpoint: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
