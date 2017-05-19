//
//  SharePhotoViewController.swift
//  OnTheWayMain
//
//  Created by nueola on 5/9/17.
//  Copyright © 2017 junwoo. All rights reserved.
//

import UIKit
import AVFoundation

class SharePhotoViewController: UIViewController {
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet var cameraView: UIView!
    var captureSession = AVCaptureSession()

    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var kmIcon: UIImageView!
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    @IBOutlet weak var walkingMan: UIImageView!
    
    @IBOutlet weak var takephotoButton: UIButton!
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDualCamera,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        for device in (deviceSession?.devices)! {
            if device.position == AVCaptureDevicePosition.back {
                do{
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = .portrait
                            
                            cameraView.layer.addSublayer(previewLayer)
                            cameraView.addSubview(takephotoButton)
                            cameraView.addSubview(appTitle)
                            cameraView.addSubview(walkingMan)
                            cameraView.addSubview(stepsLabel)
                            cameraView.addSubview(kmIcon)
                            cameraView.addSubview(kmLabel)
                            
                            
                            previewLayer.position = CGPoint (x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            previewLayer.bounds = cameraView.frame
                            
                            captureSession.startRunning()
                        }
                    }
                }catch let avError {
                    print(avError)
                }
            }
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        
    }

   
}
