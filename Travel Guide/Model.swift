import SwiftUI
import CoreLocation
import MapKit

/// Easily throw generic errors with a text description.
extension String: Error { }

class Model: ObservableObject {

    @AppStorage("language") var lang = "en"

    @Published var items: [GeoSearchItem] = []

    private let locationManager: LocationManager
    private var lastLocation: CLLocation?

    @MainActor
    init() {
        locationManager = LocationManager()
    }

    private func locationsUrl(location: CLLocation, picontinue: Int? = nil) -> URL? {
        var components = URLComponents(string: String(format: "https://%@.m.wikipedia.org/w/api.php", lang))
        components?.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "prop", value: "pageimages|coordinates|info"),
            URLQueryItem(name: "meta", value: ""),
            URLQueryItem(name: "generator", value: "geosearch"),
            URLQueryItem(name: "pithumbsize", value: "150"),
            URLQueryItem(name: "inprop", value: "url"),
            URLQueryItem(name: "ggscoord", value: "\(location.coordinate.latitude)|\(location.coordinate.longitude)"),
            URLQueryItem(name: "ggsradius", value: "10000"),
            URLQueryItem(name: "ggslimit", value: "500"),
            URLQueryItem(name: "colimit", value: "500"),
            URLQueryItem(name: "codistancefrompoint", value: "\(location.coordinate.latitude)|\(location.coordinate.longitude)"),
        ]

        if let pic = picontinue {
            components?.queryItems?.append(URLQueryItem(name: "picontinue", value: "\(pic)"))
        }

        return components?.url
    }

    func locateAndFetchItems(force: Bool = false) async throws {
        let location = try await locationManager.requestLocation()

        guard lastLocation?.distance(from: location) ?? .infinity > 10.0 || items.isEmpty || force else {
            return
        }

        lastLocation = location

        try await fetchItems(location: location)
    }

    @MainActor
    func fetchItems(location: CLLocation, picontinue: Int? = nil) async throws {
        guard let url = locationsUrl(location: location, picontinue: picontinue) else {
            fatalError()
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }

        guard let response = try? JSONDecoder().decode(GeoSearchResponse.self, from: data) else {
            throw "The server response was not recognized."
        }

        if picontinue != nil {
            let newThumbnailItems = response.query?.items.filter { $0.thumbnail != nil }
            items = items.map { item in
                // Let's replace the item with new one (with a thumbnail image)
                newThumbnailItems?.first(where: { $0.pageid == item.pageid }) ?? item
            }
        } else {
            items = response.query?.items
                .sorted {
                    $0.coordinates.first?.dist ?? 0.0 < $1.coordinates.first?.dist ?? 0.0
                } ?? []
        }

        if let picontinue = response.picontinue {
            try await fetchItems(location: location, picontinue: picontinue)
        }
    }
}
