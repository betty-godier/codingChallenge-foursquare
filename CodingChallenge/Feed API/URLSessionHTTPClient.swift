//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

class URLSessionHTTPCLient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from request: URLRequest, completion: @escaping (HTTPClientResult)-> Void) {
        session.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
