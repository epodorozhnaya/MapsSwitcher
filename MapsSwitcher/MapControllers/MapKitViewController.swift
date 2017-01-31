//
//  MapKitViewController.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/26/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: MapProviderViewController {
    
    var mapView: MKMapView!
    var mapAnnotation = MKPointAnnotation()

    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        
        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        mapAnnotation.coordinate = initialLocation
        mapAnnotation.title = initialAddress
        mapView.addAnnotation(mapAnnotation)
    }
    
    
    // MARK: - Gesture Recognizer
    
    override func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let touchPoint = sender.location(in: mapView)
        let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        if (mapView.annotations.count != 0) {
            mapView.removeAnnotations(mapView.annotations)
        }

        mapAnnotation.coordinate = newCoordinate
        mapAnnotation.title = loadingMessage
        mapView.addAnnotation(mapAnnotation)
        
        geocoder.reverseGeocodeCoordinate(newCoordinate) { result, error in
            if error != nil {
                self.mapAnnotation.title = self.errorMessage
            } else {
                self.mapAnnotation.title = result
            }
        }
    }
    
}


// MARK: - MKMapViewDelegate

extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationViewIdentifier = "annotationView"
        var annotationView: MKAnnotationView?

        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
        }

        if let annotationView = annotationView {
            let image = UIImage(named: "PinIcon")!
            annotationView.image = image
            annotationView.canShowCallout = false
            annotationView.centerOffset = CGPoint(x: CGFloat(0), y: -image.size.height/2)
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let calloutView = CalloutView(frame: .zero)
        calloutView.addressLabel.text = view.annotation?.title ?? errorMessage
        
        view.addSubview(calloutView)
        calloutView.sizeToFit()
        
        let frameWidth = calloutView.bounds.size.width
        let frameHeight = calloutView.bounds.size.height
        let frameOriginX = view.bounds.origin.x + view.bounds.size.width/2.0 - frameWidth/2.0
        let frameOriginY = view.bounds.origin.y - frameHeight
        calloutView.frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        calloutView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            calloutView.alpha = 1
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKAnnotationView.self) {
            for subview in view.subviews {
                UIView.animate(withDuration: 0.2, animations: {
                    subview.alpha = 0
                }, completion: { _ in
                    subview.removeFromSuperview()
                })
            }
        }
    }

}
