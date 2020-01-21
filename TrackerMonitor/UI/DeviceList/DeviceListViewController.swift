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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated)
        
       // viewModel.refresh(completion: nil)
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
     
        return viewModel.deviceCount
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            viewModel.removeDevice(index: indexPath.row)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let deviceController = segue.destination as? DeviceViewController
        if let row = tableView.indexPathForSelectedRow?.row{
           let device = viewModel.devices.value[row]
           deviceController?.device = device
        }
    }

}
