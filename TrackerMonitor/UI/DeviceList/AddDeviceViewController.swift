//
//  AddDeviceViewController.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit
import Bond

class AddDeviceViewController: UIViewController {

    @IBOutlet var busyIndicator: UIActivityIndicatorView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var adressTextField: UITextField!
    @IBOutlet var deviceNameLabel: UILabel!
    
    private let viewModel = AddDeviceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.isBusy.bind(to: busyIndicator.reactive.isAnimating)
        viewModel.device.map{$0 != nil }.bind(to: addButton.reactive.isEnabled)
        viewModel.device.map{$0 != nil ? 1.0 : 0.5 }.bind(to: addButton.reactive.alpha)
        viewModel.deviceName.bind(to: deviceNameLabel.reactive.text)
        
        _ = adressTextField.reactive.controlEvents(.editingDidEndOnExit).observeNext(with: { [weak self] in
            self?.search()
        })
    }
    
    
    @IBAction func addDevice(_ sender: Any){
        if viewModel.addDevice() == true {
            RootViewController.sharedInstance.showAlertController(message: "Устройство успешно добавлено!")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func search(_ sedner: Any){
        search()
    }
    
    private func search(){
        
        adressTextField.resignFirstResponder()
        if let ipAdress = adressTextField.text {
           viewModel.searchDevice(ipadress: ipAdress) { (success) in
               
           }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
