//
//  DeviceListViewController.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class DeviceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var busyIndicator: UIActivityIndicatorView!
    private let viewModel = DeviceListViewModel()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.blue
        self.refreshControl.attributedTitle = NSAttributedString.init(string: "Обновление списка устройств..",
                                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue as Any])
        
        bind()
    }

    @objc private func refreshData(_ sender: Any) {
        viewModel.refresh(completion: { [weak self] success in
            self?.refreshControl.endRefreshing()
        })
    }
    
    func showBusy(){
        busyIndicator.startAnimating()
    }
    
    func hideBusy(){
        busyIndicator.stopAnimating()
    }
    
    func bind(){
        self.viewModel.isBusy.bind(to: busyIndicator.reactive.isAnimating)
        _ = self.viewModel.devices.observeNext { [weak self](result) in
            self?.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
   
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return viewModel.devices.value.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceCellID, for: indexPath)!

        let device = viewModel.devices.value[indexPath.row]
        cell.countLabel.text = "\(device.usageDayCount)"
        cell.timeLabel.text = "\(device.usageDayTime)"
        cell.amountLabel.text = ""
        cell.titleLabel.text = device.name +  " | " + (device.ipAddress ?? "")
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
