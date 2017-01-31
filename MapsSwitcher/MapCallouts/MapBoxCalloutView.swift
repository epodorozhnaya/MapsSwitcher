//
//  MapBoxCalloutView.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/27/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit
import Mapbox

class MapBoxCalloutView: UIView, MGLCalloutView {
    
    var representedObject: MGLAnnotation
    var leftAccessoryView = UIView()
    var rightAccessoryView = UIView()
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let calloutView: CalloutView
    
    
    // MARK: - Init
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        self.calloutView = CalloutView(frame: .zero)
        
        super.init(frame: .zero)

        addSubview(calloutView)
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented") 
    }
    
    
    // MARK: - MGLCalloutView
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        guard representedObject.responds(to: #selector(getter: UIPreviewActionItem.title)) else {
            return
        }
        
        view.addSubview(self)

        calloutView.addressLabel.text = representedObject.title!
        calloutView.sizeToFit()
        
        let frameWidth = calloutView.bounds.size.width
        let frameHeight = calloutView.bounds.size.height
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        if animated {
            alpha = 0
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0
                }, completion: { _ in
                    self.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }
}


