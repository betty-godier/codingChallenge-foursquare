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
    
    struct UnexpectedValuesRepresentativeError: Error {}
    
    func get(from request: URLRequest, completion: @escaping (HTTPClientResult)-> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValuesRepresentativeError()))
            }
        }.resume()
    }
}
