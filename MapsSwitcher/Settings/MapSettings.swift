//
//  MapSettingsEnums.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/25/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import Foundation


// MARK: - Constants

let mapProviderKey = "mapProvider"
let geocodingServiceKey = "geocodingService"

let defaultMapProvider = MapProvider.apple
let defaultGeocodingService = GeocodingService.apple


// MARK: - Enums

enum MapSetting {
    case mapProvider
    case geocodingService
}

enum MapProvider: String {
    case apple = "Apple (MapKit)"
    case mapbox = "MapBox"
    
    static let allValues = [MapProvider.apple, MapProvider.mapbox]
    static let allValuesDescriptions = MapProvider.allValues.map { $0.rawValue }
    
    static func mapProviderFromSettings() -> MapProvider {
        let mapProvider = UserDefaults.standard.string(forKey: mapProviderKey)
        
        if let provider = mapProvider, let enumValue = MapProvider(rawValue: provider) {
            return enumValue
        } else {
            return defaultMapProvider
        }
    }
}

enum GeocodingService: String {
    case apple = "Apple (CLGeocoder)"
    case google = "Google"
    
    static let allValues = [GeocodingService.apple, GeocodingService.google]
    static let allValuesDescriptions = GeocodingService.allValues.map { $0.rawValue }
    
    static func geocodingServiceFromSettings() -> GeocodingService {
        let geocodingService = UserDefaults.standard.string(forKey: geocodingServiceKey)
        
        if let service = geocodingService, let enumValue = GeocodingService(rawValue: service) {
            return enumValue
        } else {
            return defaultGeocodingService
        }
    }
}
