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

class DeviceManager{
    
    static let sharedInstance = DeviceManager()
    
    private var _deviceIPs: Array<String> = []
    
    init() {
        
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
        
        _deviceIPs = ["192.168.0.219"]
    }
    
//    private static func performAPIRequest(route:APIRouter, completion:@escaping dataRequestHandler) -> DataRequest?{
//
//    }
    
    func updateList(completion: ((_ devices:[Device])->())?){
      
        var devices: Array<Device> = []
        let requestGroup = DispatchGroup()
        
        _deviceIPs.forEach { (deviceIP) in

            requestGroup.enter()
            let url = URL.init(string: "http://" + deviceIP)!.appendingPathComponent("usageData")
            Alamofire.request(url,
                                method: .get,
                  headers: nil).responseJSON { response in
                    if response.result.isSuccess == true,
                        let result = response.result.value as? Dictionary<String, Any> {
                        
                        if let errorDict = result["error"] as? Dictionary<String, Any>{
                            DDLogDebug(errorDict.debugDescription)
                        }
                        else if let data = result["data"] as? Dictionary<String,Any>,
                            let deviceData = try? JSONSerialization.data(withJSONObject: data as Any, options: []) {
                            
                            if let device = try? JSONDecoder.init().decode( Device.self, from: deviceData){
                                
                                device.ipAddress = response.request?.url?.host
                                devices.append(device)
                            }
                        }
                    }
                    requestGroup.leave()
            }
        }
        
        requestGroup.notify(queue: DispatchQueue.main) {
             completion?(devices)
        }
        
    }
}
