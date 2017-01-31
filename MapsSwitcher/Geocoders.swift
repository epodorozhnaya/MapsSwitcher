//
//  Geocoders.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/26/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate let noResultMessage = "No address was found"


protocol ReverseGeocoding {
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void)
}


class GoogleGeocoder: ReverseGeocoding {
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyDykklwmIUAP88Q8IKT-nL2Pqq8AcypGAI"
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void) {
        
        guard let url = URL(string: "\(baseUrl)latlng=\(coordinate.latitude),\(coordinate.longitude)&key=\(apikey)") else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            
            guard error == nil, let data = data else {
                print("Google reverse geocoding failed with error: \(error?.localizedDescription)")
                completion(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                var result: String
                
                if let json = json as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let address = results.first?["formatted_address"] as? String {
                    result = address
                } else {
                    result = noResultMessage
                }
                
                print("Google reverse geocoding result address: \(result)")
                completion(result, nil)

            } catch let error {
                print("Google reverse geocoding failed with error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        task.resume()
    }
}


extension CLGeocoder: ReverseGeocoding {
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Apple reverse geocoding failed with error: \(error!.localizedDescription)")
                completion(nil, error)
                return
            }
            
            var result: String
            
            if let address = placemarks?.first?.address() {
                result = address
            } else {
                result = noResultMessage
            }
            
            print("Apple reverse geocoding result address: \(result)")
            completion(result, nil)
        }
    }
}


extension CLPlacemark {
    
    func address() -> String? {
        let array = [thoroughfare, subThoroughfare, locality, country]
        let joinedResult = array.flatMap { $0 }.joined(separator: ", ")
        
        if joinedResult.isEmpty {
            return nil
        } else {
            return joinedResult
        }
    }
}


