//
//
// ToolButton.swift
// Camera
//
// Created by sturdytea on 19.02.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct ToolButton: View {
    
    var icon: String
    var isRedacting = false
    var action: () -> ()
    
    var body: some View {
        Button(action: { self.action() }) {
            Image(systemName: self.icon)
                .frame(width: 16)
                .foregroundStyle(isRedacting ? .black70 : .white)
                .padding()
                .clipShape(Circle())
        }
        .padding()
        .frame(width: 44)
        .background(isRedacting ? .white : .black70)
        .clipShape(Circle())
    }
}

#Preview {
    ToolButton(icon: "questionmark.circle.dashed", action: {})
}
