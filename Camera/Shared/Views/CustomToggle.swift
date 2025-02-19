//
//
// CustomToggle.swift
// Camera
//
// Created by sturdytea on 11.02.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct CustomToggle: View {
    
    @State var selection: Selection = .photo
    @Binding var isPhotoMode: Bool
    let background: Color = .black70
    let switchBackground: Color = .white
    
    var body: some View {
        HStack {
            if isPhotoMode {
                Spacer()
            }
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 31, height: 31)
                    .background(self.switchBackground)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    self.isPhotoMode = true
                                } else {
                                    self.isPhotoMode = false
                                }
                            }
                    )
                    .onTapGesture {
                        self.isPhotoMode.toggle()
                    }
                Image(systemName: isPhotoMode ? "camera.fill" : "video.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundStyle(self.background)
                    .animation(.easeInOut, value: 0.1)
            }
            .clipShape(Circle())
            if !isPhotoMode {
                Spacer()
            }
            
        }
        .frame(width: 51, height: 31)
        .padding(4)
        .background(self.background)
        .cornerRadius(90.0)
        .animation(.easeInOut(duration: 0.3), value: isPhotoMode)
    }
}
