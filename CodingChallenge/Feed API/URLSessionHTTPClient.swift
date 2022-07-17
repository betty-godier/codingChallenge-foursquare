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
    
    public func sendRequest(endpoint: Endpoint, completion: @escaping (HTTPClientResult)-> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
    
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers
        
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
                let me = data.map { $0 }
                print("✅✅✅✅✅\(data.count), \(me.description)")
            } else {
                completion(.failure(UnexpectedValuesRepresentativeError()))
            }
        }.resume()
    }
}
