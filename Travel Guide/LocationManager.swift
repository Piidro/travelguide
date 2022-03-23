import CoreLocation
import SwiftUI

@MainActor
final class LocationManager: NSObject, ObservableObject {

    var locationContinuation: CheckedContinuation<CLLocation, Error>?

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()

    @MainActor override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        authorizationStatus = manager.authorizationStatus
    }

    func requestLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation

            if authorizationStatus == .notDetermined {
                manager.requestWhenInUseAuthorization()
            } else {
                manager.requestLocation()
            }
        }
    }

    class func openLocationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            locationContinuation?.resume(throwing: "No locations found")
            return
        }

        locationContinuation?.resume(returning: newLocation)
        locationContinuation = nil // Discards the next `didUpdateLocations` calls
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // If old status was not set and we got authorized, request the location
        if status.isAuthorized {
            if authorizationStatus == .notDetermined {
                manager.requestLocation()
            }
        }

        authorizationStatus = status
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
    }
}

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        switch self {
        case .authorizedWhenInUse, .authorizedAlways: return true
        case .denied, .notDetermined, .restricted: return false
        @unknown default: return false
        }
    }
}
