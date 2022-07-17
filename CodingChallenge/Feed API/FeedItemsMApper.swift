//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let results: [Item]
    }
    // internal representation of the FeedItem
    private struct Item: Decodable {
        let distance: Int?
        let location: Location
        let name: String
        let categories: [Category]
        
        struct Location: Decodable {
            var address: String?
            var locality: String?
        }
        
        struct Category: Decodable {
            var name: String?
        }
        var item: FeedItem {
            FeedItem(name: name, address: location.address, city: location.locality, categoryName: categories[0].name, distance: distance)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        return .success(root.results.map { $0.item })
    }
}
