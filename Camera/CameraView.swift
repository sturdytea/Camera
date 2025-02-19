//
//
// CameraView.swift
// Camera
//
// Created by sturdytea on 06.02.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct CameraView: View {
    @StateObject var camera = CameraModel()
    @State var isPhotoMode = true
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            VStack {
                // MARK: - Top bar
                HStack {
                    // After recording
                    if camera.isTaken {
                        ToolButton(icon: "arrow.backward",
                                   isRedacting: camera.isTaken,
                                   action: { camera.retakePhoto() })
                        Spacer()
                    }
                    // While recording
                    if camera.isRecording {
                        // TODO: Add timer
                    }
                }
                .padding()
                
                Spacer()
                // MARK: - Bottom bar
                HStack {
                    // After recording
                    if camera.isTaken {
                        TextButton(text: camera.isSaved ? "Saved" : "Save",
                                   isRedacting: camera.isTaken,
                                   action: {
                            if !camera.isSaved && isPhotoMode {
                                camera.savePhoto()
                            }
                        })
                        Spacer()
                    }
                    // Before recording
                    else {
                        ZStack {
                            HStack() {
                                if !camera.isRecording {
                                    CustomToggle(isPhotoMode: $isPhotoMode)
                                }
                                Spacer()
                            }
                            Button {
                                if isPhotoMode {
                                    camera.takePhoto()
                                } else {
                                    camera.isRecording ? camera.stopRecording() : camera.startRecording()
                                }
                            } label: {
                                // Main Camera Button
                                ZStack {
                                    RoundedRectangle(cornerRadius: camera.isRecording ? 8 : 32)
                                        .fill(isPhotoMode ? .white : .red)
                                        .frame(width: camera.isRecording ? 40: 65, height: camera.isRecording ? 40: 65)
                                        .opacity(camera.isRecording ? 0.5 : 1)
                                        .animation(.easeOut(duration: 0.3), value: camera.isRecording)
                                    Circle()
                                        .stroke(isPhotoMode ? .white : .red, lineWidth: camera.isRecording ? 5 : 3)
                                        .frame(width: 75, height: 75)
                                        .opacity(camera.isRecording ? 0.5 : 1)
                                        .animation(.easeOut(duration: 0.3), value: camera.isRecording)
                                }
                            }
                            HStack {
                                Spacer()
                                if !camera.isRecording {
                                    ToolButton(icon: "arrow.triangle.2.circlepath", action: { camera.switchCamera() })
                                }
                            }
                        }
                    }
                }
                .padding()
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.checkPermission()
        })
    }
}

#Preview {
    CameraView()
}
