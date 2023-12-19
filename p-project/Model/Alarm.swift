//
//  Alarm.swift
//  p-project
//
//  Created by 재훈 on 12/7/23.
//

import UIKit
import Alamofire

// MARK: - 알람 데이터
struct AlarmData: Codable {
    let err: Int // 에러가 있으면 1 없으면 0
    let alarmList: [AlarmList]

    enum CodingKeys: String, CodingKey {
        case err
        case alarmList = "alarm_list"
    }
}

// MARK: - 알람 목록
struct AlarmList: Codable {
    let binID: String? // 쓰레기통 ID
    let gu: String? // 구
    let dong: String? // 동
    let amount: Int? // 적재량
    let time: String? // 기록된 시간
    let fire: String? // 화재 여부
    let img: String? // 이미지
    
    // 서버에서 JSON으로 오는 변수명
    enum CodingKeys: String, CodingKey {
        case binID = "bin_id"
        case gu, dong, amount, time, fire, img
    }
}


