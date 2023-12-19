//
//  ListCell.swift
//  p-project
//
//  Created by 재훈 on 12/8/23.
//

import UIKit

// MARK: - ListViewController의 테이블에서 사용하기 위한 Cell 정의
class ListCell: UITableViewCell {
    
    @IBOutlet weak var binIdLabel: UILabel! // 쓰레기통 ID
    
    @IBOutlet weak var guLabel: UILabel! // 구
    
    @IBOutlet weak var dongLabel: UILabel! // 동
    
    @IBOutlet weak var loadageLabel: UILabel! // 적재량
    
    @IBOutlet weak var replaceTimeLabel: UILabel! // 쓰레기통 교체 날짜
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
