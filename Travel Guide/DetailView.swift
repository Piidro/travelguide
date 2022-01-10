import SwiftUI
import MapKit

struct DetailView: View {
    var item: GeoSearchItem

    var body: some View {
        WebView(url: item.fullurl)
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle(item.title ?? "Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigate()
                    } label: {
                        Image(systemName: "mappin.circle")
                            .font(.system(.headline))
                    }
                }
            }
    }

    private func navigate() {
        if let coordinate = item.coordinates.first?.location.coordinate {
            let place = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: place)
            mapItem.name = item.title

            let options = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
            ]

            MKMapItem.openMaps(with: [mapItem], launchOptions: options)
        }
    }
}
