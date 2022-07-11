//
//      2022  Betty Godier
//      Coding challenge
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct PlaceListView: View {
    @StateObject var viewModel = PlaceListViewModel()
    @ObservedObject var locationManager = MyLocationManager.shared
    private var alertView = AlertView()
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        LocationButton(.shareMyCurrentLocation) {
                            viewModel.giveActualLocation()
                        }
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .tint(.teal)
                        .padding(.bottom)
                    }
                    .task(id: viewModel.currentLocation) {
                        await viewModel.loadPlace()
                    }
                    Divider()
                    radiusSlider
                    placesList
                }
                .task(id: viewModel.radius, priority: .background) {
                    await viewModel.loadPlace()
                }
                .navigationBarTitle("", displayMode: .inline)
                if viewModel.isLoading {
                    AppProgressView()
                    Text(viewModel.loadingMessage)
                        .foregroundColor(.teal)
                }
            }
            .onAppear {
                MyLocationManager.shared.requestLocation()
            }
            .padding()
        }
        .navigationViewStyle(.stack)
    }
    
    var radiusSlider: some View {
        VStack(alignment: .leading) {
            Text(viewModel.titleSlider)
                .font(.headline)
            Slider(value: $viewModel.radius,
                   in: 0...100000,
                   step: 500
            ) {
                Text("Radius")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100 000")
                    .font(.caption)
            } onEditingChanged: { editing in
                viewModel.isEditing = editing
            }
            Text("Your current radius: " + String(format: "%.0f", viewModel.radius))
                .foregroundColor(viewModel.isEditing ? .red : .blue)
                .font(.caption)
        }
        .padding(.all, 20)
    }
    
    @ViewBuilder
    var placesList: some View {
        List {
            ForEach(viewModel.getGroups(), id: \.self)  { group in
                Section(content: {
                    ForEach(self.viewModel.places.filter { $0.categoryName == group }) { place in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(place.name ?? "name")
                                Text(place.address ?? "adress")
                                Text(place.city ?? "city")
                            }
                            .font(.subheadline)
                            Spacer()
                            Text(String(place.distance ?? 200) + " meters")
                                .font(.caption)
                        }
                    }
                    
                }, header: { Text(group) })
            }
        }
        .alert(isPresented: $viewModel.isPresentedError) {
            Alert(view: self.alertView)
        }
        .padding()
        .refreshable {
            await viewModel.loadPlace()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Search places")
                    .font(.system(.title2))
            }
            ToolbarItem(placement: .bottomBar) {
                Text("Betty Godier - coding challenge ")
                    .font(.system(.caption))
            }
        }
    }
}

struct AppProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .teal))
            .scaleEffect(3)
    }
}


struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
