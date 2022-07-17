//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
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

enum PlacesEndPoint {
    case search(radius: String)
}


extension PlacesEndPoint: Endpoint {
    var host: String {
        switch self {
        case .search:
            return "api.foursquare.com"
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v3/places/search"
        }
    }
    var headers: [String : String]? {
        let API_KEY: String = "fsq30r6nfST8Lshf1/RpuiASATH0ZDXUSvcPOb/Ws+zLhcQ="
        switch self {
        case .search:
            return [
                "Authorization": API_KEY,
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let radius):
            return [
                URLQueryItem(name: "ll", value: ""),
                URLQueryItem(name: "radius", value: radius)
            ]
        }
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
