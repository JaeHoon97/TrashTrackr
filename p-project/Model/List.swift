//
//  List.swift
//  p-project
//
//  Created by 재훈 on 12/7/23.
//

import UIKit
import Alamofire

// MARK: - 쓰레기통 데이터
struct ListData: Codable {
    let err: Int // 에러가 있으면 1 없으면 0
    let binList: [BinList]

    enum CodingKeys: String, CodingKey {
        case err
        case binList = "bin_list"
    }
}

// MARK: - 쓰레기통 목록
struct BinList: Codable {
    let binID: String? // 쓰레기통 ID
    let gu: String? // 구
    let dong: String? // 동
    let lat, lon: Double? // 위도, 경도
    let installDate: String? // 쓰레기통 설치 날짜
    let amount: Int? // 적재량
    let loadTime: String? // 적재량 등록 날짜
    let rpTime, empID, fireTime: String? // 봉투 교체 날짜, 관리자 ID, 화재 날짜
    
    // 서버에서 JSON으로 오는 변수명
    enum CodingKeys: String, CodingKey {
        case binID = "bin_id"
        case gu, dong, lat, lon
        case installDate = "install_date"
        case amount
        case loadTime = "load_time"
        case rpTime = "rp_time"
        case empID = "emp_id"
        case fireTime = "fire_time"
    }
}


