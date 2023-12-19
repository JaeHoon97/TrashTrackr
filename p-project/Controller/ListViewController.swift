//
//  ListViewController.swift
//  p-project
//
//  Created by 재훈 on 12/7/23.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var binListArray: [BinList] = []
    var networkManager = NetworkManager.shared
    var refreshControl: UIRefreshControl!
    let dong = UserDefaults.standard.string(forKey: "dong")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setupData()
    }
    
    
    func setupData() {
        let type = UserDefaults.standard.string(forKey: "pos")
        networkManager.fetchBin(type: type!){ datas in
            guard let binDatas = datas else { return }
            self.binListArray = binDatas
            
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


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.binListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        
        
        cell.binIdLabel.text = "쓰레기통ID: " + binListArray[indexPath.row].binID!
        cell.guLabel.text = binListArray[indexPath.row].gu! + "구"
        cell.dongLabel.text = binListArray[indexPath.row].dong! + "동"
        cell.loadageLabel.text = "현재 적재량: " + String(binListArray[indexPath.row].amount!) + "%"
        if(binListArray[indexPath.row].amount! <= 40){
            cell.loadageLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.6649876608, blue: 0.3058823529, alpha: 1)
        } else if(binListArray[indexPath.row].amount! <= 80){
            cell.loadageLabel.textColor = #colorLiteral(red: 1, green: 0.6039215686, blue: 0, alpha: 1)
        } else {
            cell.loadageLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1960784314, alpha: 1)
        }
        if(binListArray[indexPath.row].rpTime != nil){
            cell.replaceTimeLabel.text = "마지막 교체: " + binListArray[indexPath.row].rpTime!
        } else {
            cell.replaceTimeLabel.text = "최근 교체 없음"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}

