//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case Error(Error)
}

protocol FeedLoader {
    func loadPlace(completion: @escaping (LoadFeedResult) -> Void)
}
