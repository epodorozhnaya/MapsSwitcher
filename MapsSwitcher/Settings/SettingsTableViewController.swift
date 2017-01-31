//
//  SettingsTableViewController.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/24/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit


class SettingsTableViewController: UITableViewController, PickerTableViewControllerDelegate {

    // MARK: - Constants
    
    let chooseMapProviderIdentifier = "chooseMapProviderIdentifier"
    let chooseGeocodingServiceIdentifier = "chooseGeocodingServiceIdentifier"
    
    let chooseMapProviderNavigationTitle = "Choose Provider"
    let chooseGeocodingServiceNavigationTitle = "Choose Service"
    
    
    // MARK: - Properties
    
    @IBOutlet weak var mapProviderDetailLabel: UILabel!
    @IBOutlet weak var geocodingServiceDetailLabel: UILabel!
    
    var modifiedSetting: MapSetting?
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapProviderDetailLabel.text = UserDefaults.standard.string(forKey: mapProviderKey)
        geocodingServiceDetailLabel.text = UserDefaults.standard.string(forKey: geocodingServiceKey)
    }
    
    
    // MARK: - PickerTableViewControllerDelegate
    
    func didSelectNewValue(_ value: String) {
        switch modifiedSetting! {
        case .mapProvider:
            UserDefaults.standard.set(value, forKey: mapProviderKey)
        case .geocodingService:
            UserDefaults.standard.set(value, forKey: geocodingServiceKey)
        }
    }
    
    func didFinishUpdates(withValue value: String) {
        switch modifiedSetting! {
        case .mapProvider:
            mapProviderDetailLabel.text = value
        case .geocodingService:
            geocodingServiceDetailLabel.text = value
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let pickerTableViewController = segue.destination as? PickerTableViewController {
            
            if segue.identifier == chooseMapProviderIdentifier {
                modifiedSetting = .mapProvider
                pickerTableViewController.delegate = self
                pickerTableViewController.valuesArray = MapProvider.allValuesDescriptions
                pickerTableViewController.selectedValue = mapProviderDetailLabel.text
                pickerTableViewController.navigationItem.title = chooseMapProviderNavigationTitle

            } else if segue.identifier == chooseGeocodingServiceIdentifier {
                modifiedSetting = .geocodingService
                pickerTableViewController.delegate = self
                pickerTableViewController.valuesArray = GeocodingService.allValuesDescriptions
                pickerTableViewController.selectedValue = geocodingServiceDetailLabel.text
                pickerTableViewController.navigationItem.title = chooseGeocodingServiceNavigationTitle
            }
        }
    }
}
