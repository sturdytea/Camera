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
                
                HStack {
                    if camera.isTaken {
                        Button {
                            if !camera.isSaved {
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
                    } else {
                        Button {
                            camera.takePhoto()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
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
