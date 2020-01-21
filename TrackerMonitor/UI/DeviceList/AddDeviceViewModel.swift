//
//  AddDeviceViewModel.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import Bond

class AddDeviceViewModel{
    
    let isBusy = Observable<Bool>(false)
    let device = Observable<Device?>(nil)
    let deviceName = Observable<String>("")
    
    func searchDevice(ipadress: String,  completion: ((_ success: Bool)->())?){
        
        isBusy.value = true
        DeviceManager.sharedInstance.getDevice(idAdress: ipadress) { [weak self] (device, errorMessage) in
            self?.isBusy.value = false
            self?.device.value = device
            self?.deviceName.value = device?.name ?? ""
            completion?(device != nil)
        }
    }
    
    func addDevice() -> Bool{
        if let newDevice = device.value {
           return DeviceManager.sharedInstance.addDevice(device: newDevice)
        }
        
        return false
    }
}
