//
//  MapProviderViewController.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/26/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit
import CoreLocation

class MapProviderViewController: UIViewController {
    
    // MARK: - Constants
    
    let initialLocation = CLLocationCoordinate2D(latitude: 50.441562, longitude: 30.521119)
    let initialAddress = "Kyiv, Ukraine"
    
    let loadingMessage = "loading..."
    let errorMessage = "Error occurred"
    
    
    // MARK: - Geocoders
    
    lazy var actualGeocodingService = {
        GeocodingService.geocodingServiceFromSettings()
    }()
    
    lazy var actualGeocoder: ReverseGeocoding = {
        self.makeGeocoder(forService: self.actualGeocodingService)
    }()
    
    var geocoder: ReverseGeocoding {
        if actualGeocodingService != GeocodingService.geocodingServiceFromSettings() {
            actualGeocodingService = GeocodingService.geocodingServiceFromSettings()
            actualGeocoder = makeGeocoder(forService: actualGeocodingService)
        }
        return actualGeocoder
    }
    
    private func makeGeocoder(forService service: GeocodingService) -> ReverseGeocoding {
        switch service {
        case .apple:
            return CLGeocoder()
        case .google:
            return GoogleGeocoder()
        }
    }

    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecogniser.minimumPressDuration = 0.5
        view.addGestureRecognizer(longPressRecogniser)
    }
    
    
    // MARK: - Gesture Recognizer
    
    func handleLongPress(sender: UILongPressGestureRecognizer) { }
    
}



