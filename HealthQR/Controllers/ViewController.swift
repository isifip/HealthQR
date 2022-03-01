//
//  ViewController.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import UIKit
import SwiftQRScanner
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var btnScan: CustomButton!
    
    func alertPromptToAllowCameraAccess() {
        let alert = UIAlertController(title: "Allow Camera Access", message: "Access to the camera has been disabled for this app. In order to use this app you must tap the Settings buttons and allow access to camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { alert in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { result in
                //
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func startScanner() {
        let scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: nil, flashOnImage: UIImage(named: "flash"), flashOffImage: UIImage(named: "flash-off"))
        
        scanner.delegate = self
        scanner.modalPresentationStyle = . fullScreen
        self.present(scanner, animated: true)
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        if session.devices.count > 0 {
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch authStatus {
            case .notDetermined:
                alertPromptToAllowCameraAccess()
            case .restricted:
                alertPromptToAllowCameraAccess()
            case .denied:
                alertPromptToAllowCameraAccess()
            case .authorized:
                startScanner()
            @unknown default:
                fatalError()
            }
        } else {
            
            #if targetEnvironment(simulator)
            processResults(result: Constants.SMART_HEALTH_CARD_TEST)
            #else
            let alert = UIAlertController(title: "Warning", message: "It appears your device does not have a camera. Your device must have a camera in order to use this app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            #endif
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Verifier"
        
    }

}


extension ViewController: QRScannerCodeDelegate {
    
    func processResults(result: String) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "resultsViewController") as! ResultsViewController
        SmartHealthCardReader.shared().parseSmartHealthCard(qrCodeString: result) { [weak self] shcresults in
            guard let self = self else { return }
            if let shcresult = shcresults {
                DispatchQueue.main.async {
                    vc.shcresults = shcresults
                    self.present(vc, animated: true)
                }
            }
        }
        //self.present(vc, animated: true)
    }
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        processResults(result: result)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("Error: \(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQrScanned did cancel")
    }
    
    
}



