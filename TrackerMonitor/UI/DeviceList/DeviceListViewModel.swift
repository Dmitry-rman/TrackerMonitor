//
//  DeviceListViewModel.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import Bond

class DeviceListViewModel{
    
    let isBusy = Observable<Bool>(false)
    let devices = DeviceManager.sharedInstance.devices
    
    var deviceCount: Int{
        return devices.value.count
    }
    
    init() {
        refresh(completion: nil)
    }
    
    func refresh(completion: ((_ success: Bool)->())?){
        self.isBusy.value = true
        DeviceManager.sharedInstance.updateList { [weak self] (results) in
                   self?.isBusy.value = false
                   completion?(true)
               }
    }
    
    func removeDevice(index: Int){
        
        let device = DeviceManager.sharedInstance.devices.value[index]
        _ = DeviceManager.sharedInstance.removeDevice(device: device)
    }
}
