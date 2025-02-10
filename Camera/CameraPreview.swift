//
//
// CameraPreview.swift
// Camera
//
// Created by sturdytea on 06.02.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        DispatchQueue.main.async {
            let preview = AVCaptureVideoPreviewLayer(session: camera.session)
            preview.frame = view.bounds
            preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(preview)
            camera.preview = preview
        }
        DispatchQueue.global(qos: .background).async {
            camera.session.startRunning()
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
