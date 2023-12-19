//
//  QRScanViewController.swift
//  p-project
//
//  Created by 재훈 on 12/16/23.
//

import UIKit
import AVFoundation
import Eureka


class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    let defaults = UserDefaults.standard
    let speechSynthesizer = AVSpeechSynthesizer()
    var isScanning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카메라 장치 설정
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("카메라를 사용할 수 없습니다.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            guard let videoPreviewLayer = videoPreviewLayer else { return }
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
            
            // QR 코드가 인식될 때 표시될 프레임
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrCodeFrameView.layer.borderWidth = 5
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            print("카메라 입력을 설정하는 도중 에러가 발생했습니다.")
            return
        }
    }
    
    // QR 코드 인식 시 호출되는 함수
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 || !isScanning {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) {
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            // QR 코드의 내용을 추출하여 사용할 수 있습니다.
            if let qrCodeContent = metadataObj.stringValue {
                // 추출한 QR 코드 내용을 사용합니다.
                print(qrCodeContent)
                guard let empId = defaults.string(forKey: "LoggedInUserID")  else { return }
                print(empId)
                
                guard let url = URL(string: qrCodeContent) else {
                    print("Error: cannot create URL")
                    return
                }
                
                // 업로드할 모델(형태)
                struct UploadData: Codable {
                    let emp_id: String
                }
                
                // 실제 업로드할 (데이터)인스턴스 생성
                let uploadDataModel = UploadData(emp_id: empId)
                
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
                    
                }.resume()
                
                speak("교체가 완료됬습니다.")
                self.isScanning = false
                self.captureSession.stopRunning()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func speak(_ message: String) {
        let speechUtterance = AVSpeechUtterance(string: message)
        speechSynthesizer.speak(speechUtterance)
    }
    
}
