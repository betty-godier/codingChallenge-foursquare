//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var method: String {
        return  "GET"
    }
}

enum PlacesEndPoint: Endpoint {
    var host: String {
        return "api.foursquare.com"
    }
    
    var path: String {
        return "/v3/places/search"
    }
    var headers: [String : String]? {
        let API_KEY: String = "fsq30r6nfST8Lshf1/RpuiASATH0ZDXUSvcPOb/Ws+zLhcQ="
        return [
            "Authorization": API_KEY,
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    var body: [String : String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "ll", value: ""),
            URLQueryItem(name: "radius", value: "")
        ]
    }
}

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
