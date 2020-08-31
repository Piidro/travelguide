//
//  Model.swift
//  TravelGuide2
//
//  Created by Petri Tilli on 18.3.2020.
//  Copyright © 2020 Petri Tilli. All rights reserved.
//

import Foundation
import CoreLocation

class Model: NSObject {

    private let locationManager: CLLocationManager = CLLocationManager()
    private let parser: GeoSearchParser = GeoSearchParser()

    private var currentLocation: CLLocation?

    var locale: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "locale")
        }
        get {
            return UserDefaults.standard.string(forKey: "locale") ?? "en"
        }
    }

    static var shared: Model {
        return Model()
    }

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func locate() {
        locationManager.requestLocation()
    }

    func loadWikiLocations(amount: Int, location: CLLocation) {

        var urlString = "https://\(locale).wikipedia.org/w/api.php?"

        urlString += "action=query"
        urlString += "&list=geosearch"
        urlString += "&format=xml"
        urlString += "&gsradius=10000"
        urlString += "&gslimit=\(amount)"
        urlString += "&gscoord=\(location.coordinate.latitude)%%7C\(location.coordinate.longitude)"

        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            if (error != nil) {
                debugPrint("FAILED with error \(error!)")

                let alertText = "For some reason, I cannot connect to Wikipedia right now. Please try again later."

                //TODO: Display error
            }
            else if data != nil {
                //self.parser.parse(data: data!)
            }

        }.resume()
    }
}

extension Model: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        currentLocation = locations.last

        if currentLocation != nil {
            loadWikiLocations(amount: 500, location: currentLocation!)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}
