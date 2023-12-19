//
//  AlarmViewController.swift
//  p-project
//
//  Created by 재훈 on 12/7/23.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alarmListArray: [AlarmList] = []
    var networkManager = NetworkManager.shared
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setupData()
        
    }
    
    func setupData(){
        let type = UserDefaults.standard.string(forKey: "pos")
        print(type!)
        networkManager.fetchAlarm(type: type!) { datas in
            guard let alarmDatas = datas else { return }
            self.alarmListArray = alarmDatas
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
    }
    @objc func refreshData() {
        setupData()
    }
    
}



extension AlarmViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarmListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        if let base64String = alarmListArray[indexPath.row].img,
           let imageData = Data(base64Encoded: base64String),
           let image = UIImage(data: imageData) {
            cell.mainImageView.image = image
            
        } else {
            cell.mainImageView.image = UIImage(named: "trash")
        }
        
        cell.binIdLabel.text = "쓰레기통ID: " + alarmListArray[indexPath.row].binID!
        cell.guLabel.text = alarmListArray[indexPath.row].gu! + "구"
        cell.dongLabel.text = alarmListArray[indexPath.row].dong! + "동"
        if(alarmListArray[indexPath.row].amount != nil) {
            cell.alarmLabel.text = "적재량 경고!     적재량: " + String(alarmListArray[indexPath.row].amount!) + "%"
        } else {
            cell.alarmLabel.text = "화재발생! 🔥"
        }
        cell.detailLabel.text = alarmListArray[indexPath.row].time!
        
        return cell
    }
    
}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
