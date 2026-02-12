//
//  ToastView.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/12/26.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) private var colorScheme
    var payload: ToastPayload
    
    private var backgroundColor: Color {
        Color(uiColor: .secondarySystemBackground)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color.white500 : Color.main700
    }
    
    private var shadowColor: Color {
        Color.black.opacity(colorScheme == .dark ? 0.18 : 0.08)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            payload.style.icon
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(Color.white500)
                .padding(8)
                .background(Circle().fill(payload.style.tintColor))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(payload.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(payload.style.tintColor)
                
                Text(payload.message)
                    .font(.system(size: 12))
                    .foregroundStyle(textColor)
            }
            
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(payload.style.tintColor, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: shadowColor, radius: 8, x: 0, y: 3)
    }
}
