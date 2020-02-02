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
    private var timeoutTimer: Timer?
    
    private var getDeviceCompletion: ((_ device: Device?, _ errorMessage: String?)->())?
    private var updateListCompletion: ((_ devices:[Device]?)->())?
    
    let devices = Observable<[Device]>([])
    
    var deviceIPs: Array<String>{
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
    
    private func startRequestTimer(){
        stopRequesTimer()
        timeoutTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                            target: self,
                                            selector: #selector(timoutTimerFile),
                                            userInfo: nil,
                                            repeats: false)
    }
    
    private func stopRequesTimer(){
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
    @objc private func timoutTimerFile(){
        getDeviceCompletion?(nil, "Превышен интервал запроса")
        updateListCompletion?(nil)
    }
    
//    private static func performAPIRequest(route:APIRouter, completion:@escaping dataRequestHandler) -> DataRequest?{
//
//    }
    
    func addDevice(device: Device) -> Bool{
        
        var devicesIPS: Array<String> = deviceIPs
        devicesIPS.append(device.ipAddress!)
        UserDefaults.standard.setValue(devicesIPS , forKey: DeviceManager.kDevicesKey)
        
        self.updateList(completion: nil)
        
        return UserDefaults.standard.synchronize()
    }
    
    func removeDevice(deviceIP: String) -> Bool{
        var devicesIPS: Array<String> = deviceIPs
        devicesIPS.removeAll{ $0 == deviceIP}
        UserDefaults.standard.setValue(devicesIPS , forKey: DeviceManager.kDevicesKey)
        
        devices.value.removeAll{ $0.ipAddress == deviceIP}
        
        return UserDefaults.standard.synchronize()
    }
    
    
    func clearDevice(device: Device, completion: ((_ success: Bool)->())?){
        
        if let ip = device.ipAddress{
            let url = URL.init(string: "http://" + ip)!.appendingPathComponent("clearCount")
            Alamofire.request(url, method: .post).responseJSON { response in
                completion?(response.result.isSuccess)
            }
        }
        else{
            completion?(false)
        }
    }
    
    func getDevice(idAdress: String, handleTimeout: Bool = true, completion: ((_ device: Device?, _ errorMessage: String?)->())?){
        
        if handleTimeout {
            startRequestTimer()
            getDeviceCompletion = completion
        }
        
        let url = URL.init(string: "http://" + idAdress)!.appendingPathComponent("usageData")
        Alamofire.request(url,
                            method: .get,
              headers: nil).responseJSON { [weak self] response in
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
                            if let index = self?.devices.value.lastIndex(where: { (aDevice) -> Bool in
                                return aDevice.ipAddress == device.ipAddress
                            }) {
                               self?.devices.value.remove(at: index)
                               self?.devices.value.insert(device, at: index)
                            }else{
                                self?.devices.value.append(device)
                            }
                            
                            completion?(device, nil)
                        }
                        else{
                            completion?(nil, "Device parsing error")
                        }
                    }
                }
  
                self?.getDeviceCompletion = nil
        }
    }
    
    func updateList(completion: ((_ devices:[Device]?)->())?){
      
        startRequestTimer()
        updateListCompletion = completion
        let requestGroup = DispatchGroup()
        
        deviceIPs.forEach { (deviceIP) in

            requestGroup.enter()
            self.getDevice(idAdress: deviceIP, handleTimeout: false) { (device, message) in
                 requestGroup.leave()
            }
        }
        
        requestGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.updateListCompletion = nil
            completion?(self?.devices.value ?? [])
        }
        
    }
}
