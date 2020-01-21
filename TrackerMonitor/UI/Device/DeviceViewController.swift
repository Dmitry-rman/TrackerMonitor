//
//  DeviceViewController.swift
//  TrackerMonitor
//
//  Created by Dmitry on 21.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class DeviceViewController: UITableViewController {
    
    var device: Device?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = device?.name
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
