//
//  ReplacementViewController.swift
//  p-project
//
//  Created by 재훈 on 12/11/23.
//

import UIKit
import Alamofire

class ReplacementViewController: UIViewController {
    
    @IBOutlet weak var binIdTextField: UITextField!
    
    @IBOutlet weak var empIdTextField: UITextField!
    
    @IBOutlet weak var replacementButton: UIButton!
    
    @IBOutlet weak var QRCodeScanButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.binIdTextField.layer.cornerRadius = 8
        self.binIdTextField.layer.borderWidth = 1
        self.binIdTextField.layer.borderColor = UIColor.black.cgColor
        
        self.empIdTextField.layer.cornerRadius = 8
        self.empIdTextField.layer.borderWidth = 1
        self.empIdTextField.layer.borderColor = UIColor.black.cgColor
        self.empIdTextField.text = defaults.string(forKey: "empId")
        self.empIdTextField.isUserInteractionEnabled = false
        
        self.replacementButton.layer.cornerRadius = 8
        self.replacementButton.layer.borderWidth = 1
        self.replacementButton.layer.borderColor = UIColor.black.cgColor
        
        self.QRCodeScanButton.layer.cornerRadius = 8
        self.QRCodeScanButton.layer.borderWidth = 1
        self.QRCodeScanButton.layer.borderColor = UIColor.black.cgColor
        
        binIdTextField.delegate = self
        empIdTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    @IBAction func replaceButtonTapped(_ sender: Any) {
        guard let binId = binIdTextField.text, let empId = empIdTextField.text else { return }
        print(binId, empId)
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60036/m/replacement") else {
            print("Error: cannot create URL")
            return
        }
        
        // 업로드할 모델(형태)
        struct UploadData: Codable {
            let bin_id: String
            let emp_id: String
        }
        
        // 실제 업로드할 (데이터)인스턴스 생성
        let uploadDataModel = UploadData(bin_id: binId, emp_id: empId)
        
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
            
            // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
            print(String(decoding: safeData, as: UTF8.self))
            DispatchQueue.main.async {
                self.showAlert()
            }
        }.resume()
    }
    
    @IBAction func QRCodeScanButtonTapped(_ sender: UIButton) {
        let qrScanViewController = QRScanViewController()
        self.present(qrScanViewController, animated: true, completion: nil)
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "봉투교체 완료", message: "정상적으로 교체되었습니다!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
}

extension ReplacementViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == binIdTextField {
            empIdTextField.becomeFirstResponder()
        }
        if textField == empIdTextField {
            empIdTextField.resignFirstResponder()
        }
        
        return true
    }
}
