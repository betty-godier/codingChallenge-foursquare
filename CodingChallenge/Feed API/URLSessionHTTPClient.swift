//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentativeError: Error {}
    
    public func sendRequest(endpoint request: URLRequest, completion: @escaping (HTTPClientResult)-> Void) {
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
