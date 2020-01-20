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
    
    let devices = Observable<[Device]>([])
    let isBusy = Observable<Bool>(false)
    
    init() {
        refresh(completion: nil)
    }
    
    func refresh(completion: ((_ success: Bool)->())?){
        self.isBusy.value = true
        DeviceManager.sharedInstance.updateList { [weak self] (results) in
                   self?.isBusy.value = false
                   self?.devices.value = results
                   completion?(true)
               }
    }
}
