//
//  Login.swift
//  p-project
//
//  Created by 재훈 on 12/15/23.
//

import Foundation
import Alamofire

// MARK: - 관리자 데이터
struct LoginData: Codable {
    // JSON 데이터의 필드에 따라 모델 프로퍼티를 정의
    let err: Int // 에러가 있으면 1 없으면 0
    let empInfo: [EmpInfo]
    
    // 서버에서 JSON으로 오는 변수명
    enum CodingKeys: String, CodingKey {
        case err
        case empInfo = "emp_info"
    }
}

// MARK: - 관리자 정보
struct EmpInfo: Codable {
    let empId: String? // 관리자 ID
    let name: String? // 이름
    let tell: String? // 전화번호
    let gu: String? // 구
    let dong: String? // 동
    let pos: Int? // 관리지역 번호
    
    // 서버에서 JSON으로 오는 변수명
    enum CodingKeys: String, CodingKey {
        case empId = "emp_id"
        case tell = "tel"
        case name, gu, dong, pos
    }
}

// MARK: - 비밀번호 변경 데이터
struct ChangePWData: Codable {
    
    let err: Int // 에러가 있으면 1 없으면 0
    
    // 서버에서 JSON으로 오는 변수명
    enum CodingKeys: String, CodingKey {
        case err
    }
}
