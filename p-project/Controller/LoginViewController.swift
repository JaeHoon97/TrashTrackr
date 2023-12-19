//
//  LoginViewController.swift
//  p-project
//
//  Created by 재훈 on 12/2/23.
//

import UIKit

// MARK: - 로그인 화면 세팅
class LoginViewController: UIViewController {
    
    struct EmpInfo: Codable {
        let empId: String? // 관리자 ID
        let name: String? // 이름
        let tell: String? // 전화번호
        let gu: String? // 구
        let dong: String? // 동
    }
    
    private let mainTitleLabel: UILabel = { // 로그인 화면에서 앱 타이틀 세팅
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "Cafe24SsurroundOTF", size: 40)
        label.text = "Trash\nTrackr"
        label.textColor = #colorLiteral(red: 0.8928521276, green: 0.3257680237, blue: 0.4888171554, alpha: 1)
        return label
    }()
    
    private let IDView: UIView = { // 아이디 입력 창을 넣기 위한 뷰 세팅
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9333333333, blue: 0.9176470588, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let IDTextField: UITextField = { // 아이디 입력 창 세팅
        let tf = UITextField()
        tf.keyboardType = .emailAddress
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(
            string: "아이디 입력",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return tf
    }()
    
    private let PWView: UIView = { // 비밀번호 입력 창을 넣기 위한 뷰 세팅
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9333333333, blue: 0.9176470588, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let PWTextField: UITextField = { // 비밀번호 입력 창 세팅
        let tf = UITextField()
        tf.keyboardType = .emailAddress
        tf.textColor = .black
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(
            string: "비밀번호 입력",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        tf.addTarget(self, action: #selector(PWtextFieldEditingChanged), for: .editingChanged)
        return tf
    }()
    
    private let PWButton: UIButton = { // 비밀번호 표시 버튼 세팅
        let bt = UIButton(type: .custom)
        bt.setTitle("표시", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 14)
        bt.addTarget(self, action: #selector(PWTextFieldSecureMode), for: .touchUpInside)
        return bt
    }()
    
    private let loginButton: UIButton = { // 로그인 버튼 세팅
        let bt = UIButton()
        bt.setTitle("로그인", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont(name: "Cafe24SsurroundOTF", size: 17)
        bt.titleLabel?.textAlignment = .center
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .white
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.black.cgColor
        bt.addTarget(self, action: #selector(loginButtontapped), for: .touchUpInside)
        return bt
    }()
    
    private let PWResetButton: UIButton = { // 비밀번호 찾기 버튼 세팅
        let bt = UIButton()
        bt.setTitle("비밀번호 찾기", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont(name: "Cafe24SsurroundOTF", size: 17)
        bt.titleLabel?.textAlignment = .center
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .white
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.black.cgColor
        bt.addTarget(self, action: #selector(passwordResetButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private lazy var stackView: UIStackView = { // 아이디 입력, 비밀번호 입력, 로그인 버튼을 스택 뷰로 묶음
        let sv = UIStackView(arrangedSubviews: [IDView, PWView, loginButton])
        sv.axis = .vertical
        sv.spacing = 18
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.backgroundColor = .clear
        return sv
    }()
    
    private let webSocketManager = WebSocketManager() // 웹소켓 통신 연결 변수
    
    private let defaults = UserDefaults.standard // 로컬 데이터 저장 변수
    
    override func viewDidLoad() { // 화면이 뜨기 전 세팅
        super.viewDidLoad()
        webSocketManager.connectWebSocket()
        view.backgroundColor = .white
        view.addSubview(mainTitleLabel)
        view.addSubview(stackView)
        view.addSubview(PWResetButton)
        view.addSubview(PWButton)
        view.addSubview(IDTextField)
        view.addSubview(PWTextField)
        setupConstraints()
        IDTextField.delegate = self
        PWTextField.delegate = self
    }
    
    func setupConstraints() { // 레이아웃 설정
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        IDView.translatesAutoresizingMaskIntoConstraints = false
        IDTextField.translatesAutoresizingMaskIntoConstraints = false
        
        PWView.translatesAutoresizingMaskIntoConstraints = false
        PWTextField.translatesAutoresizingMaskIntoConstraints = false
        PWButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        PWResetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            mainTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            mainTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            
            
            stackView.heightAnchor.constraint(equalToConstant: 180),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            IDView.heightAnchor.constraint(equalToConstant: 48),
            IDTextField.centerXAnchor.constraint(equalTo: IDView.centerXAnchor),
            IDTextField.centerYAnchor.constraint(equalTo: IDView.centerYAnchor),
            IDTextField.trailingAnchor.constraint(equalTo: IDView.trailingAnchor, constant: -60),
            IDTextField.leadingAnchor.constraint(equalTo: IDView.leadingAnchor, constant: 8),
            IDTextField.heightAnchor.constraint(equalToConstant: 30),
            
            PWView.heightAnchor.constraint(equalToConstant: 48),
            PWTextField.centerXAnchor.constraint(equalTo: PWView.centerXAnchor),
            PWTextField.centerYAnchor.constraint(equalTo: PWView.centerYAnchor),
            PWTextField.trailingAnchor.constraint(equalTo: PWView.trailingAnchor, constant: -60),
            PWTextField.leadingAnchor.constraint(equalTo: PWView.leadingAnchor, constant: 8),
            PWTextField.heightAnchor.constraint(equalToConstant: 30),
            PWButton.centerYAnchor.constraint(equalTo: PWView.centerYAnchor),
            
            PWButton.trailingAnchor.constraint(equalTo: PWView.trailingAnchor, constant: -8),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            PWResetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            PWResetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            PWResetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            PWResetButton.heightAnchor.constraint(equalToConstant: 48)
            
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 화면을 터치 시 키보드 내리기
        self.view.endEditing(true)
    }
    
    @objc func PWTextFieldSecureMode() { // 비밀번호 표시 버튼 함수
        PWTextField.isSecureTextEntry.toggle()
    }
    
    @objc func loginButtontapped() {
        login { responseData in
            if responseData.err == 0 {
                let res = responseData.empInfo[0]
                print(res)
                
                UserDefaults.standard.set(res.gu!, forKey: "gu")
                UserDefaults.standard.set(res.dong!, forKey: "dong")
                UserDefaults.standard.set(res.empId!, forKey: "empId")
                UserDefaults.standard.set(res.name!, forKey: "name")
                UserDefaults.standard.set(res.tell!, forKey: "tell")
                UserDefaults.standard.set(res.pos!, forKey: "pos")
                
                let alert = UIAlertController(title: "로그인 성공", message: "\(self.defaults.string(forKey: "name") ?? "홍길동")님 반갑습니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                    self.transitionToTabBarController()
                    self.IDTextField.text = ""
                    self.PWTextField.text = ""
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            } else {
                let alert = UIAlertController(title: "로그인 실패", message: "아이디 혹은 비밀번호가 틀렸습니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
    }
    
    func transitionToTabBarController() {
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }
    @objc func passwordResetButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 재설정", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancle)
        present(alert, animated: true)
    }
    
    @objc func PWtextFieldEditingChanged() {
        if IDTextField.text?.isEmpty == false {
            if PWTextField.text?.isEmpty == false {
                loginButton.backgroundColor = #colorLiteral(red: 1, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
                return
            }
            else {
                loginButton.backgroundColor = .clear
                return
            }
        }
    }
    
    func login(completion: @escaping (LoginData) -> Void ) {
        guard let id = self.IDTextField.text, let pw = self.PWTextField.text else { return }
        print(id, pw)
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60036/m/login") else {
            print("Error: cannot create URL")
            return
        }
        
        // 업로드할 모델(형태)
        struct UploadData: Codable {
            let id: String
            let password: String
        }
        
        // 실제 업로드할 (데이터)인스턴스 생성
        let uploadDataModel = UploadData(id: id, password: pw)
        
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
                let responseData = try decoder.decode(LoginData.self, from: safeData)
                
                // responseData를 사용하여 필요한 작업 수행
                print("Response Data err: \(responseData.err)")
                DispatchQueue.main.async {
                    completion(responseData)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
        }.resume()
    }
}


// MARK: - 텍스트필드 델리게이트
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == IDTextField {
            PWTextField.becomeFirstResponder()
        }
        if textField == PWTextField {
            loginButtontapped()
        }
        
        return true
    }
}
