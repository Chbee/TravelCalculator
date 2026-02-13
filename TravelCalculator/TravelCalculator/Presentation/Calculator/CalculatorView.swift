//
//  CalculatorView.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var store = CalculatorStore()
    
    private var toastBinding: Binding<ToastPayload?> {
        Binding(
            get: { store.state.toast },
            set: { _ in store.send(.dismissToast) }
        )
    }
    
    var body: some View {
        return GeometryReader { proxy in
            let width = proxy.size.width * 0.8
            
            VStack(spacing: 16) {
                // 디스플레이
                Text(store.state.formattedDisplay)
                    .font(.system(size: 40, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(height: 52, alignment: .trailing)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(store.state.isInputLimitExceeded ? Color.red : Color.gray900)
                    .animation(.easeInOut(duration: 0.1), value: store.state.isInputLimitExceeded)
                
                // 키패드
                CalculatorKeypad(
                    state: store.state,
                    send: store.send
                )
            }
            .frame(width: width)
            .frame(maxWidth: .infinity)
        }
        .toast(toastBinding)
        .onChange(of: store.state.isInputLimitExceeded) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    store.send(.resetInputLimitFlag)
                }
            }
        }
    }
}

#Preview {
    CalculatorView()
}
