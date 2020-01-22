//
//  DeviceViewController.swift
//  TrackerMonitor
//
//  Created by Dmitry on 21.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableDirector: TableDirector!
    
    var viewModel: DeviceViewModel! = nil
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.blue
        self.refreshControl.attributedTitle = NSAttributedString.init(string: "Обновление..",
                                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue as Any])

        tableDirector = TableDirector(tableView: tableView, scrollDelegate: nil)
     
        _ = viewModel.deviceName.observeNext { [weak self] (name) in
            self?.title = name
        }
        
        _ = viewModel.device.observeNext {[weak self] (device) in
            self?.reloadTable()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.refresh(completion: { [weak self] success in
            self?.refreshControl.endRefreshing()
        })
    }
    
    private func reloadTable(){
        
        tableDirector.clear()
        let section = TableSection(headerTitle: "Информация об устройстве", footerTitle: nil)
        
        if let device = self.viewModel.device.value {
            
            section += TableRow<TitleSubtitleCell>(item: (title: "Имя", subtitle: device.name, accessoryType: .none))
            section += TableRow<TitleSubtitleCell>(item: (title: "IP адрес", subtitle: device.ipAddress ?? "", accessoryType: .none))
            section += TableRow<TitleSubtitleCell>(item: (title: "Кол-во запусков", subtitle: "\(device.usageDayCount)", accessoryType: .none))
            section += TableRow<TitleSubtitleCell>(item: (title: "Время работы", subtitle: "\(device.usageDayTime)" , accessoryType: .none))
            section += TableRow<TitleSubtitleCell>(item: (title: "Выручка", subtitle: "", accessoryType: .none))
        }
        tableDirector += section
        tableDirector.reload()
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
