//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public protocol HTTPClient {
    func get(from url: URLRequest, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}
