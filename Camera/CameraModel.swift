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

final class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    @Published var isTaken = false
    @Published var alert = false
    
    var session: AVCaptureSession = {
        var session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()
    
    var output = AVCapturePhotoOutput()
    var videoOutput = AVCaptureMovieFileOutput()
    var preview: AVCaptureVideoPreviewLayer?
    
    @Published var isSaved = false
    @Published var photoData = Data(count: 0)
    @Published var isRecording = false
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] videoGranted in
                AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                    DispatchQueue.main.async {
                        if videoGranted && audioGranted {
                            self?.setup()
                        } else {
                            self?.alert.toggle()
                        }
                    }
                }
            }

        case .denied, .restricted:
            DispatchQueue.main.async {
                self.alert.toggle()
            }
            
        case .authorized:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] audioGranted in
                DispatchQueue.main.async {
                    if audioGranted {
                        self?.setup()
                    } else {
                        self?.alert.toggle()
                    }
                }
            }

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
                
                guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
                    print("! No available microphone found")
                    return
                }
                
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                
                if self.session.canAddInput(audioInput) {
                    self.session.addInput(audioInput)
                }
                
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                
                if self.session.canAddOutput(self.videoOutput) {
                    self.session.addOutput(self.videoOutput)
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
    
    func startRecording() {
        guard !videoOutput.isRecording else { return }
        
        guard !videoOutput.connections.isEmpty else {
            print("No active connections for video output")
            return
        }
        
        session.beginConfiguration()
        session.removeOutput(videoOutput)
        
        videoOutput = AVCaptureMovieFileOutput()
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        session.commitConfiguration()
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mov")
        videoOutput.startRecording(to: url, recordingDelegate: self)
        
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }
    
    func stopRecording() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
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
        
        DispatchQueue.main.async {
            DispatchQueue.global(qos: .background).async {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            self.isSaved = true
            print("Photo Saved Successfully")
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if error != nil {
            print(error?.localizedDescription ?? "Error recording video")
            return
        }
        
        saveVideo(outputFileURL)
        
        DispatchQueue.main.async {
                self.isRecording = false
            }
    }
    
    func saveVideo(_ url: URL) {
        UISaveVideoAtPathToSavedPhotosAlbum(url.path(), nil, nil, nil)
        print("Video Saved Successfully")
    }
}
