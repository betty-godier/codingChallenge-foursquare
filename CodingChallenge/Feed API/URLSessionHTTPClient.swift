//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

class URLSessionHTTPCLient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from request: URLRequest) {
        session.dataTask(with: request) { _, _, _ in }.resume()
    }
}
