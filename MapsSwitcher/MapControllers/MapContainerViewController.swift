//
//  MapContainerViewController.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/24/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit

class MapContainerViewController: UIViewController {
    
    var actualMapProvider = MapProvider.mapProviderFromSettings()
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        installViewController(forProvider: actualMapProvider)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if actualMapProvider != MapProvider.mapProviderFromSettings() {
            actualMapProvider = MapProvider.mapProviderFromSettings()

            installViewController(forProvider: actualMapProvider)
        }
    }
    
    
    // MARK: -
    
    private func installViewController(forProvider provider: MapProvider) {
        let viewController: UIViewController
        
        switch provider {
        case .apple:
            viewController = MapKitViewController()
        case .mapbox:
            viewController = MapBoxViewController()
        }
        
        if let childViewController = childViewControllers.last {
            childViewController.willMove(toParentViewController: nil)
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParentViewController()
        }
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }

}




