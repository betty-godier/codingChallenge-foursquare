//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func sendRequest(endpoint: Endpoint, completion: @escaping (HTTPClientResult) -> Void)
}
