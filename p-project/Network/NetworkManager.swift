//
//  Network.swift
//  p-project
//
//  Created by 재훈 on 12/10/23.
//

import UIKit
import Alamofire

// MARK: - 네트워크 세팅
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchBin(type: String, completionHandler: @escaping ([BinList]?) -> Void) {
        let url = "http://ceprj.gachon.ac.kr:60036/m/list/\(type)"
        
        performBinRequest(with: url) { bin in
            completionHandler(bin)
        }
    }
    
    func fetchAlarm(type: String, completionHandler: @escaping ([AlarmList]?) -> Void) {
        let url = "http://ceprj.gachon.ac.kr:60036/m/alarm/\(type)"
        
        performAlarmRequest(with: url) { bin in
            completionHandler(bin)
        }
    }
    
    private func performBinRequest(with urlString: String, completionHandler: @escaping ([BinList]?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("목록 에러1")
                completionHandler(nil)
                return
            }
            
            guard let safeData = data else {
                print("목록 에러2")
                completionHandler(nil)
                return
            }
            
            if let binList = self.parseBinJSON(safeData) {
                print("목록 parse 실행")
                completionHandler(binList)
            }
            else {
                print("목록 parse 실패")
                completionHandler(nil)
            }
        }
        
        task.resume()
    }
    
    private func performAlarmRequest(with urlString: String, completionHandler: @escaping ([AlarmList]?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("알람 에러1")
                completionHandler(nil)
                return
            }
            
            guard let safeData = data else {
                print("알람 에러2")
                completionHandler(nil)
                return
            }
            
            if let binList = self.parseAlarmJSON(safeData) {
                print("알람 parse 실행")
                completionHandler(binList)
            }
            else {
                print("알람 parse 실패")
                completionHandler(nil)
            }
        }
        
        task.resume()
    }
    
    private func parseBinJSON(_ binData: Data) -> [BinList]? {
        do {
            let binData = try JSONDecoder().decode(ListData.self, from: binData)

            return binData.binList
            
        } catch {
            print("목록 json 에러")
            return nil
        }
        
    }
    private func parseAlarmJSON(_ alarmData: Data) -> [AlarmList]? {
        do {
            let alarmData = try JSONDecoder().decode(AlarmData.self, from: alarmData)

            return alarmData.alarmList
            
        } catch {
            print("알람 json 에러")
            return nil
        }
        
    }
        
}
