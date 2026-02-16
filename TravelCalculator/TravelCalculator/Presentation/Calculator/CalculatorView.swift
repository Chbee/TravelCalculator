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
                // 툴바
                CalculatorToolbar(
                    currency: .KRW, // TODO: 선택된 통화 연결
                    isOnline: true, // TODO: 네트워크 상태 연결
                    lastUpdated: "방금 전", // TODO: 실제 업데이트 시간 연결
                    onCurrencyTap: { /* TODO: 통화 선택 화면 이동 */ },
                    onCameraTap: { /* TODO: 카메라 기능 */ },
                    onSettingsTap: { /* TODO: 설정 화면 이동 */ }
                )

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
