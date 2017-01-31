//
//  PickerTableViewController.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/24/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit


protocol PickerTableViewControllerDelegate {
    func didSelectNewValue(_ value: String)
    func didFinishUpdates(withValue value: String)
}


class PickerTableViewController: UITableViewController {

    let settingsDetailsCellIdentifier = "settingsDetailsCellIdentifier"
    
    
    // MARK: - Properties
    
    var delegate: PickerTableViewControllerDelegate?
    
    var valuesArray: [String]!
    var selectedValue: String! {
        didSet {
            selectedIndex = valuesArray.index(of: selectedValue)
        }
    }
    var selectedIndex: Int!
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            delegate?.didFinishUpdates(withValue: selectedValue!)
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsDetailsCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = valuesArray[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        selectedValue = valuesArray[indexPath.row]
        delegate?.didSelectNewValue(selectedValue)
    }
}
