//
//
// TextButton.swift
// Camera
//
// Created by sturdytea on 19.02.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct TextButton: View {
    
    var text: String
    var isRedacting = false
    var action: () -> ()
    
    var body: some View {
        Button { self.action() } label: {
                Text(self.text)
                .foregroundStyle(isRedacting ? .black70 : .white)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isRedacting ? .white : .black70)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    TextButton(text: "Text", action: {})
}
