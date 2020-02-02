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
    
    var deviceCount: Int{
        return DeviceManager.sharedInstance.deviceIPs.count
    }
    
    func getDeviceIP(byIndex index: Int) -> String{
        return DeviceManager.sharedInstance.deviceIPs[index]
    }
    
    func getDevice(byIndex index: Int) -> Device?{
        
        let ip = self.getDeviceIP(byIndex: index)
        return  DeviceManager.sharedInstance.devices.value.filter{$0.ipAddress == ip}.first
    }
    
    init() {
        refresh(completion: nil)
    }
    
    func refresh(completion: ((_ success: Bool)->())?){
        self.isBusy.value = true
        DeviceManager.sharedInstance.updateList { [weak self] (results) in
                   self?.isBusy.value = false
                   completion?(results != nil)
               }
    }
    
    func removeDevice(ip: String){
        _ = DeviceManager.sharedInstance.removeDevice(deviceIP: ip)
    }
}
