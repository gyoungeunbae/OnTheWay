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
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet weak var square: UIView!
    
    var session = AVCaptureSession()
    var camera : AVCaptureDevice?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCapturreSession()
        self.square.layer.borderWidth = 1
        self.square.layer.borderColor = UIColor.white.cgColor
        cameraView.addSubview(square)
        
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        self.view.addSubview(navigationBar);
        let navigationItem = UINavigationItem(title: "")
        let backItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
        let galleryItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(gotoLibrary))
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = galleryItem
        navigationBar.setItems([navigationItem], animated: false)
    }
    func gotoLibrary() {
    
    }
    func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayCapturPhoto(capturePhoto: UIImage) {
        let sharePhotoPreViewController = storyboard?.instantiateViewController(withIdentifier: "SharePhotoPreVC")as! SharePhotoPreViewController
        sharePhotoPreViewController.capturedImage = capturePhoto
       self.present(sharePhotoPreViewController, animated: true)
    }
    

    @IBAction func takePhoto(_ sender: Any) {
        takePicture()
    }
    
    func initializeCapturreSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
        let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
        cameraCaptureOutput = AVCapturePhotoOutput()
            
        session.addInput(cameraCaptureInput)
        session.addOutput(cameraCaptureOutput)
        } catch {
            print(error.localizedDescription)
        }
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
        
    }
    
   
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        cameraCaptureOutput.capturePhoto(with: settings, delegate: self)
        
    }
}


extension SharePhotoViewController : AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let unwrappedError = error {
            print(unwrappedError.localizedDescription)
        } else {
            
            if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                
                if let finalImage = UIImage(data: dataImage) {
                    
                    displayCapturPhoto(capturePhoto: finalImage)
                }
            }
        }
    }
}
