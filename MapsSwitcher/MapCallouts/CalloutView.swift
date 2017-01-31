//
//  CalloutView.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/27/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit

class CalloutView: UIView {
    
    let tipWidth: CGFloat = 20.0
    let tipHeight: CGFloat = 10.0
    let addressLabelInset: CGFloat = 10.0
    let calloutColor = UIColor(red: 50/255.0, green: 90/255.0, blue: 119/255.0, alpha: 0.9)
    
    @IBOutlet var addressLabel: UILabel!
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupView()
    }
    
    private func setupView() {
        if let addressView = Bundle.main.loadNibNamed("AddressView", owner: self, options: nil)?.first as? UIView {
            
            addSubview(addressView)
    
            backgroundColor = .clear
            
            addressView.backgroundColor = calloutColor
            addressView.layer.cornerRadius = 7.0
            addressView.translatesAutoresizingMaskIntoConstraints = false
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let viewsDictionary = ["subView": addressView, "label": addressLabel]
            let metrics = ["tipHeight": tipHeight, "inset": addressLabelInset]
            let constraints =
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewsDictionary) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]-tipHeight-|", options: [], metrics: metrics, views: viewsDictionary) +
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-inset-[label]-inset-|", options: [], metrics: metrics, views: viewsDictionary) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-inset-[label]-inset-|", options: [], metrics: metrics, views: viewsDictionary)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    
    // MARK: -
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let addressSize = addressLabel.sizeThatFits(size)
        let width = addressSize.width + (addressLabelInset * 2)
        let height = addressSize.height + (addressLabelInset * 2) + tipHeight
        return CGSize(width: width, height: height)
    }
    
    override func draw(_ rect: CGRect) {
        let tipLeftX = rect.origin.x + rect.size.width/2.0 - tipWidth/2.0
        let tipBottomX = rect.origin.x + rect.size.width/2.0
        let tipBottomY = rect.origin.y + rect.size.height
        let tipTopY = rect.size.height - tipHeight
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeftX, y: tipTopY))
        tipPath.addLine(to: CGPoint(x: tipBottomX, y: tipBottomY))
        tipPath.addLine(to: CGPoint(x: tipLeftX + tipWidth, y: tipTopY))
        tipPath.closeSubpath()
        
        if let currentContext = UIGraphicsGetCurrentContext() {
            currentContext.setFillColor(calloutColor.cgColor)
            currentContext.addPath(tipPath)
            currentContext.fillPath()
        }
    }

}

