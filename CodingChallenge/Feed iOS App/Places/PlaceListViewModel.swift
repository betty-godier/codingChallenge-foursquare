//
//      2022  Betty Godier
//      Coding challenge
//

import Foundation

@MainActor
class PlaceListViewModel: ObservableObject {
    @Published var places = [Place]()
    @Published var isLoading = false
    @Published var loadingMessage = ""
    @Published var isEditing: Bool = false
    var currentLocation: String?
    @Published var errorApp: RemoteFeedLoader.Error?
    @Published var isPresentedError = false
    var titleSlider: String = "Control your radius of interest\n(max 100 000 meters)"
    var radius: Double = 100000.0
    @Published var showUserLocation: Bool = false
    var currentRadius: Int {
        return Int(Int32(radius))
    }
    var locationManager = MyLocationManager()

    @MainActor
    func getPlace() async throws {
        performNetworkCall()
        if let request = urlRequest() {
            let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
            let mapData = try FeedPlacesMapper.map(data, from: response as! HTTPURLResponse)
            DispatchQueue.main.async {
                self.places = mapData
            }
        }
    }
    @MainActor func loadPlace() async {
        do {
            try await getPlace()
        } catch {
            self.isPresentedError.toggle()
        }
    }
}

extension PlaceListViewModel {
    var urlWithQuery: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.foursquare.com"
        components.path = "/v3/places/search"
        components.queryItems = [
            URLQueryItem(name: "radius", value: "\(currentRadius)"),
            URLQueryItem(name: "ll", value: currentLocation)
        ]
        return components.url
    }
    func urlRequest() -> URLRequest? {
        guard let url = urlWithQuery else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("fsq30r6nfST8Lshf1/RpuiASATH0ZDXUSvcPOb/Ws+zLhcQ=", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
}

extension PlaceListViewModel {
    func getGroups() -> [String] {
        var groups: [String] = []
        
        for category in places {
            if !groups.contains(category.categoryName ?? "") {
                groups.append(category.categoryName ?? "")
            }
        }
        return groups
    }
}

extension PlaceListViewModel {
    
    func performNetworkCall() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.loadingMessage = "In progress"
        }
    }
    func giveActualLocation() {
        locationManager.requestAllowOnceLocationPermission()
        currentLocation = locationManager.actualLocation
    }
}
