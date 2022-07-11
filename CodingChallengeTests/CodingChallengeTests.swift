//
//      2022  Betty Godier
//      Coding challenge
//

import SwiftUI
import XCTest
@testable import CodingChallenge

class PlaceListViewModelTests: XCTestCase {
    
    var placeListViewModel: PlaceListViewModel!
//    var locationManager: FakeLocationManager!
    
    @MainActor override func setUp() {
        placeListViewModel = PlaceListViewModel()
//        locationManager = FakeLocationManager()
    }
    
    func testDownloadWebData() async throws {
        let request = URLRequest(url: URL(string: "https://a-url.com")!)
        
        let dataAndResponse: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        _ = dataAndResponse.1 as? HTTPURLResponse
        
        let httpResponse = try XCTUnwrap(dataAndResponse.response as? HTTPURLResponse, "Expected an HTTPURLResponse.")
        XCTAssertEqual(httpResponse.statusCode, 200, "Expected a 200 OK response.")
    }
    
    // MARK: Helpers
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = [ "items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> Swift.Error {
        return error
    }
    
    //        let amsterdamLocation = makeLocation(lat: 52.3676, long: 4.9041)
    private func makeLocation(lat: Double, long: Double) {
    }
    
    private func makeItem(id: UUID, name: String? = nil, address: String? = nil, city: String? = nil, categoryName: String? = nil, distance: Int? = nil) -> (model:Place, json: [String: Any]) {
        let item = Place(name: name, address: address, city: city, distance: distance ?? 20, categoryName: categoryName ?? "")
        let json = [
            "name": name,
            "address": address,
            "categoryName": categoryName
        ]
            .compactMapValues { $0 }
        
        return (item, json)
    }
    
    class FakeNetworkMonitoring {
        var isNetworkReachable: Bool = true
        func observeNetworkStatus() {
        }
    }
}
