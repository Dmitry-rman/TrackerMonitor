//
//  Device.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

class Device : Decodable{
    let usageDayTime: Int
    let usageDayCount: Int
    var name: String
    var ipAddress: String?
}
