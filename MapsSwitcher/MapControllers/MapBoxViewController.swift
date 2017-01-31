//
//  MapBoxViewController.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/26/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit
import Mapbox

class MapBoxViewController: MapProviderViewController {

    var mapView: MGLMapView!
    var pointAnnotation = MGLPointAnnotation()
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.setCenter(initialLocation, zoomLevel: 12, animated: false)
        
        pointAnnotation.coordinate = initialLocation
        pointAnnotation.title = initialAddress
        mapView.addAnnotation(pointAnnotation)
    }
    
    
    // MARK: - Gesture Recognizer
    
    override func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let touchPoint = sender.location(in: mapView)
        let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        pointAnnotation.coordinate = newCoordinate
        pointAnnotation.title = loadingMessage
        mapView.addAnnotation(pointAnnotation)
        
        geocoder.reverseGeocodeCoordinate(newCoordinate) { result, error in
            if error != nil {
                self.pointAnnotation.title = self.errorMessage
            } else {
                self.pointAnnotation.title = result
            }
        }
    }
}


// MARK: - MGLMapViewDelegate

extension MapBoxViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annotationImageIdentifier = "annotationImage"
        
        if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: annotationImageIdentifier) {
            return annotationImage
            
        } else {
            let image = UIImage(named: "PinIconForMapBox")!
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0)
            let insetImage = image.withAlignmentRectInsets(inset)
            return MGLAnnotationImage(image: insetImage, reuseIdentifier: annotationImageIdentifier)
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            return MapBoxCalloutView(representedObject: annotation)
        }
        return nil
    }

    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
    }

}



