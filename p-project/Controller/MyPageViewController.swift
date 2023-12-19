//
//  MyPageViewController.swift
//  p-project
//
//  Created by 재훈 on 12/7/23.
//

import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var userAffiliationLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var passwordResetButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoutButton.layer.cornerRadius = 8
        self.logoutButton.layer.borderWidth = 1
        self.logoutButton.layer.borderColor = UIColor.black.cgColor
        
        self.passwordResetButton.layer.cornerRadius = 8
        self.passwordResetButton.layer.borderWidth = 1
        self.passwordResetButton.layer.borderColor = UIColor.black.cgColor
        
        self.userAffiliationLabel.layer.cornerRadius = 8
        self.userAffiliationLabel.layer.borderWidth = 1
        self.userAffiliationLabel.layer.borderColor = UIColor.black.cgColor
        
        self.userNameLabel.text = "이름: " + defaults.string(forKey: "name")!
        self.userIdLabel.text = "아이디: " + defaults.string(forKey: "empId")!
        self.userAffiliationLabel.text = "소속: \(defaults.string(forKey: "gu")!)구 \(defaults.string(forKey: "dong")!)동"
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
