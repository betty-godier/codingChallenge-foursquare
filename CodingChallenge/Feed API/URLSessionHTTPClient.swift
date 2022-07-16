//
//      2022  Betty.dev 
//

import Foundation

class URLSessionHTTPCLient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from request: URLRequest) {
        session.dataTask(with: request) { _, _, _ in }
    }
}
