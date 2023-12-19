import UIKit


// MARK: - 웹소켓 통신
class WebSocketManager: NSObject, URLSessionWebSocketDelegate, UNUserNotificationCenterDelegate {
    
    private var webSocket: URLSessionWebSocketTask?
    
    func connectWebSocket() { // 웹소켓 연결
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "ws://ceprj.gachon.ac.kr:60036") // 웹소켓 주소
        
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }
    
    func ping() { // 웹소켓 연결 확인 핑
        webSocket?.sendPing { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        }
    }
    
    func close() { // 웹소켓 연결 해제
        webSocket?.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
    }
    
    func send() { // 데이터 보내기
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send()
            self.webSocket?.send(.string("Send new message: \(Int.random(in: 0...1000))"), completionHandler: { error in
                if let error = error {
                    print("Send error: \(error)")
                }
            })
        }
    }
    
    func receive() { // 데이터 받기
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got Data: \(data)")
                case .string(let jsonString):
                    print("Got String: \(jsonString)")
                    
                    if let jsonData = jsonString.data(using: .utf8),
                        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        
                        if let binId = jsonObject["bin_id"] as? String, let amount = jsonObject["amount"] as? Int{
                            // 로컬 알림 전송
                            DispatchQueue.main.async {
                                self?.sendLocalNotification(binId: binId, amount: amount)
                            }
                            
                        }
                        
                    }
                    
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Receive Error: \(error)")
            }
            
            self?.receive()
        })
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did connect to socket")
        ping()
        receive()
        send()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection with reason")
    }
    
    func sendLocalNotification(binId: String, amount: Int) { //화재 or 적재량이 90% 이상 도달하여 서버에서 알림이 올 경우 관리자에게 메시지 전송
        let content = UNMutableNotificationContent()
        let notificationIdentifier = "binNotification_\(Date().timeIntervalSince1970)"
        if (amount == -1) { // 화재가 났을 경우
            content.title = "쓰레기통 화재 경고 알림"
            content.body = "쓰레기통 ID: \(binId)에 화재가 감지되었습니다!"
            content.sound = UNNotificationSound.default
        } else { // 적재량이 90 넘었을 경우
            content.title = "쓰레기통 적재량 경고 알림"
            content.body = "쓰레기통 ID: \(binId)에 적재량이 \(amount)% 도달했습니다!"
            content.sound = UNNotificationSound.default
        }
        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            content.badge = NSNumber(value: currentBadgeCount + 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
           
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("로컬 알림 전송 실패: \(error.localizedDescription)")
            } else {
                print("로컬 알림 전송 성공")
            }
        }
    }
}
