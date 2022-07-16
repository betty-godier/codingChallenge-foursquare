//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation


protocol HTTPSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}


class URLSessionHTTPCLient {
    private let session: HTTPSession
    
    init(session: HTTPSession) {
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
