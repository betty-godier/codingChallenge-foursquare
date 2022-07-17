//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(radius: String, completion: @escaping (LoadFeedResult) -> Void)
}
