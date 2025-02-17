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
    
    enum Selection {
        case photo, video
    }
    
    @State var selection: Selection = .photo
    @Binding var isPhotoMode: Bool
    
    var body: some View {
        HStack {
            Text(isPhotoMode ? "Photo" : "Video")
            Toggle("", isOn: $isPhotoMode)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .gray))
        }
    }
}

