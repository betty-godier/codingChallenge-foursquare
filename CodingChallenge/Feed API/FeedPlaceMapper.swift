//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

final class FeedPlacesMapper {
    private struct Root: Decodable {
        let results: [Result]
        var feed: [Place] {
            return results.map(\.feedPlace)
        }
    }
    private struct Result: Codable {
        let categories: [Category]
        let distance: Int
        let location: Location
        let name: String
        
        var feedPlace: Place {
            return Place(name: name, address: location.address, city: location.locality, distance: distance, categoryName: categories[0].categoryName)
        }
    }
    private struct Category: Codable {
        let categoryName: String
        enum CodingKeys: String, CodingKey {
            case categoryName = "name"
        }
    }
    private struct Location: Codable {
        let address: String
        let locality: String
    }
    
    private static var OK_200: Int { return 200 }
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Place] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.feed
    }
}
