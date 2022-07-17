//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public struct FeedItem: Equatable {
    public let id = UUID()
    public let name: String
    public let address: String?
    public let city: String?
    public let categoryName: String?
    public let distance: Int?
    
    public init(name: String, address: String?, city: String?, categoryName: String?, distance: Int?) {
        self.name = name
        self.address = address
        self.city = city
        self.categoryName = categoryName
        self.distance = distance
    }
}
