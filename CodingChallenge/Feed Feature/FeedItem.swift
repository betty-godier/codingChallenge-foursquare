//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

struct FeedItem: Equatable {
    var id = UUID()
    var name: String?
    var address: String?
    var city: String?
    var categoryName: String?
    var distance: Int?
}
