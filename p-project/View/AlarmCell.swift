//
//  AlarmCell.swift
//  p-project
//
//  Created by 재훈 on 12/7/23.
//

import UIKit

// MARK: - AlarmViewController의 테이블에서 사용하기 위한 Cell 정의 
class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView! // 테이블 뷰
    
    @IBOutlet weak var binIdLabel: UILabel! // 쓰레기통 ID
    
    @IBOutlet weak var guLabel: UILabel! // 구
    
    @IBOutlet weak var dongLabel: UILabel! // 동
    
    @IBOutlet weak var alarmLabel: UILabel! // 알람 ( 적재량 또는 화재 여부 )
    
    @IBOutlet weak var detailLabel: UILabel! // 상세 설명
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}
