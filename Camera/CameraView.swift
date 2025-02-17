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
                
                if camera.isTaken {
                    HStack {
                        Spacer()
                        Button {
                            camera.retakePhoto()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                }
                
                Spacer()
                // Bottom bar
                HStack {
                    // After recording
                    if camera.isTaken {
                        Button {
                            if !camera.isSaved && isPhotoMode {
                                camera.savePhoto()
                            }
                        } label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(.white)
                                .clipShape(Capsule())
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    // Before recording
                    else {
                        CustomToggle(isPhotoMode: $isPhotoMode)
                        Spacer()
                        
                        Button {
                            if isPhotoMode {
                                camera.takePhoto()
                            } else {
                                camera.isRecording ? camera.stopRecording() : camera.startRecording()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(isPhotoMode ? .white : .red)
                                    .frame(width: 65, height: 65)
                                    .opacity(camera.isRecording ? 0.5 : 1)
                                    .animation(.easeOut(duration: 0.3), value: camera.isRecording)
                                Circle()
                                    .stroke(isPhotoMode ? .white : .red, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                                    .opacity(camera.isRecording ? 0.5 : 1)
                                    .animation(.easeOut(duration: 0.3), value: camera.isRecording)
                            }
                        }
                        
                        Spacer()
                        Spacer()
                    }
                }
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
