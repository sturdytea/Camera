//
//
// CameraModel.swift
// Camera
//
// Created by sturdytea on 06.02.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import AVFoundation
import SwiftUI

final class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var alert = false
    var session = AVCaptureSession()
    var output = AVCapturePhotoOutput()
    var preview: AVCaptureVideoPreviewLayer?
    
    @Published var isSaved = false
    @Published var photoData = Data(count: 0)
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
                DispatchQueue.main.async {
                    if status {
                        self?.setup()
                    }
                    else {
                        self?.alert.toggle()
                    }
                }
            }
        
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.alert.toggle()
            }
        case .authorized:
            setup()
        @unknown default:
            break
        }
    }
    
    func setup() {
        DispatchQueue.global(qos: .background).async {
            do {
                self.session.beginConfiguration()
                guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) else {
                    print("! No available camera found")
                    return
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                
                self.session.commitConfiguration()
            }
            catch {
                print(error.localizedDescription)
            }

        }
    }
    
    func takePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                self.isTaken.toggle()
            }
        }
    }
    
    func retakePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                self.isTaken.toggle()
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if error != nil {
            return
        }
        
        print("Photo taken.")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        self.photoData = imageData
    }
    
    func savePhoto() {
        guard let image = UIImage(data: self.photoData) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.isSaved = true
        print("Photo Saved Successfully")
    }
}
