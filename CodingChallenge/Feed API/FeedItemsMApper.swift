//
//      2022  Betty.dev 
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let results: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let name: String
        let address: String?
        let city: String?
        let categoryName: String?
        let distance: Int?
        
        var item: FeedItem {
            FeedItem(id: id, name: name, address: address, city: city, categoryName: categoryName, distance: distance)
        }
    }
    
    private static var OK_200: Int { return 200 }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data).results.map { $0.item }
        return root
    }
}
