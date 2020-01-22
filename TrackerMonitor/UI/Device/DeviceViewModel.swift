//
//  DeviceViewModel.swift
//  TrackerMonitor
//
//  Created by Dmitry on 22.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import Bond

class DeviceViewModel{
    
    private(set) var device = Observable<Device?>(nil)
    private(set) var deviceName = Observable<String>("")
    
    init(device: Device) {
        self.device.value = device
        self.device.map{ $0?.name ?? ""}.bind(to: deviceName)
    }
    
    func refresh(completion: ((_ success: Bool)->())?){
        if let deviceIp = self.device.value?.ipAddress {
           DeviceManager.sharedInstance.getDevice(idAdress: deviceIp) { [weak self] (device, errorMessage) in
              self?.device.value = device
              completion?(device != nil)
           }
        }
    }
}
