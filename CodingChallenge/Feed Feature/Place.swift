//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public struct Place: Equatable, Identifiable {
    public var id = UUID()
    public var name: String?
    public var address: String?
    public var city: String?
    public var categoryName: String?
    public var distance: Int?
    
    init(name: String?, address: String?, city: String?,  distance: Int, categoryName: String) {
        self.name = name
        self.address = address
        self.city = city
        self.distance = distance
        self.categoryName = categoryName
    }
}

