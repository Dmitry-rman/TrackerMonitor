//
//  DeviceManager.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger
import CocoaLumberjack
import Bond

class DeviceManager{
    
    static let sharedInstance = DeviceManager()
    private static let kDevicesKey = "devices"
    
    let devices = Observable<[Device]>([])
    
    private var _deviceIPs: Array<String>{
        var devices: Array<String> = []
        if let values =  UserDefaults.standard.value(forKey: DeviceManager.kDevicesKey) as? Array<String>{
            devices = values
        }
        return devices
    }
    
    init() {
        
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
        
    }
    
//    private static func performAPIRequest(route:APIRouter, completion:@escaping dataRequestHandler) -> DataRequest?{
//
//    }
    
    func addDevice(device: Device) -> Bool{
        
        var devicesIPS: Array<String> = _deviceIPs
        devicesIPS.append(device.ipAddress!)
        UserDefaults.standard.setValue(devicesIPS , forKey: DeviceManager.kDevicesKey)
        
        self.updateList(completion: nil)
        
        return UserDefaults.standard.synchronize()
    }
    
    func removeDevice(device: Device) -> Bool{
        var devicesIPS: Array<String> = _deviceIPs
        devicesIPS.removeAll{ $0 == device.ipAddress!}
        UserDefaults.standard.setValue(devicesIPS , forKey: DeviceManager.kDevicesKey)
        
        devices.value.removeAll{ $0.ipAddress == device.ipAddress!}
        
        return UserDefaults.standard.synchronize()
    }
    
    func getDevice(idAdress: String, completion: ((_ device: Device?, _ errorMessage: String?)->())?){
        
        let url = URL.init(string: "http://" + idAdress)!.appendingPathComponent("usageData")
        Alamofire.request(url,
                            method: .get,
              headers: nil).responseJSON { response in
                if response.result.isSuccess == true,
                    let result = response.result.value as? Dictionary<String, Any> {
                    
                    if let errorDict = result["error"] as? Dictionary<String, Any>{
                        DDLogDebug(errorDict.debugDescription)
                         completion?(nil, errorDict.debugDescription)
                    }
                    else if let data = result["data"] as? Dictionary<String,Any>,
                        let deviceData = try? JSONSerialization.data(withJSONObject: data as Any, options: []) {
                        
                        if let device = try? JSONDecoder.init().decode( Device.self, from: deviceData){
                            
                            device.ipAddress = response.request?.url?.host
                            completion?(device, nil)
                        }
                        else{
                            completion?(nil, "Device parsing error")
                        }
                    }
                }
                
               
        }
    }
    
    func updateList(completion: ((_ devices:[Device])->())?){
      
        var tmpDevices: Array<Device> = []
        let requestGroup = DispatchGroup()
        
        _deviceIPs.forEach { (deviceIP) in

            requestGroup.enter()
            self.getDevice(idAdress: deviceIP) { (device, message) in
                if device != nil {
                    tmpDevices.append(device!)
                }
                 requestGroup.leave()
            }
        }
        
        requestGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.devices.value = tmpDevices
            completion?(tmpDevices)
        }
        
    }
}
