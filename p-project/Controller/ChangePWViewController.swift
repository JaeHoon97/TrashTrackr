//
//  ChangePWViewController.swift
//  p-project
//
//  Created by 재훈 on 12/17/23.
//

import Foundation
import UIKit


class ChangePWViewController: UIViewController{
    
    @IBOutlet weak var empIdTextField: UITextField!
    
    @IBOutlet weak var oldPwTextField: UITextField!
    
    @IBOutlet weak var newPwTextField: UITextField!
    
    @IBOutlet weak var changePwButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.empIdTextField.layer.cornerRadius = 8
        self.empIdTextField.layer.borderWidth = 1
        self.empIdTextField.layer.borderColor = UIColor.black.cgColor
        self.empIdTextField.text = defaults.string(forKey: "empId")
        self.empIdTextField.isUserInteractionEnabled = false
        
        self.oldPwTextField.layer.cornerRadius = 8
        self.oldPwTextField.layer.borderWidth = 1
        self.oldPwTextField.layer.borderColor = UIColor.black.cgColor
        self.oldPwTextField.isSecureTextEntry = true
        
        self.newPwTextField.layer.cornerRadius = 8
        self.newPwTextField.layer.borderWidth = 1
        self.newPwTextField.layer.borderColor = UIColor.black.cgColor
        self.newPwTextField.isSecureTextEntry = true
        
        self.changePwButton.layer.cornerRadius = 8
        self.changePwButton.layer.borderWidth = 1
        self.changePwButton.layer.borderColor = UIColor.black.cgColor
        
        oldPwTextField.delegate = self
        newPwTextField.delegate = self
        
    }
    
    @IBAction func changePwButtonTapped(_ sender: UIButton) {
        changePW { responseData in
            if responseData.err == 0 {
                let alert = UIAlertController(title: "비밀번호 변경 성공", message: "비밀번호를 성공적으로 변경했습니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            } else {
                let alert = UIAlertController(title: "비밀번호 변경 실패", message: "현재 비밀번호가 일치하지 않습니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
    } // changePwButtonTapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func changePW(completion: @escaping (ChangePWData) -> Void ) {
        guard let oldPW = oldPwTextField.text, let newPW = newPwTextField.text, let empId = empIdTextField.text else { return }
        print("변경 전 비밀번호: \(oldPW) 변경 후 비밀번호: \(newPW)")
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60036/m/pw") else {
            print("Error: cannot create URL")
            return
        }
        
        // 업로드할 모델(형태)
        struct UploadData: Codable {
            let emp_id: String
            let password: String
            let new_pw: String
        }
        
        // 실제 업로드할 (데이터)인스턴스 생성
        let uploadDataModel = UploadData(emp_id: empId, password: oldPW, new_pw: newPW)
        
        // 모델을 JSON data 형태로 변환
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        // URL요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // 요청을 가지고 작업세션시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling PUT")
                print(error!)
                return
            }
            guard let safeData = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ChangePWData.self, from: safeData)
                
                // responseData를 사용하여 필요한 작업 수행
                print("Response Data: \(responseData.err)")
                DispatchQueue.main.async {
                    completion(responseData)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
        }.resume()
    }  //changePW
} // main

extension ChangePWViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPwTextField {
            newPwTextField.becomeFirstResponder()
        }
        if textField == newPwTextField {
            newPwTextField.resignFirstResponder()
        }
        
        return true
    }
}
