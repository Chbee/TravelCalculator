//
//  CalculatorView.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject private var toastManager: ToastManager
    @EnvironmentObject private var appStore: AppStore
    
    @State private var store: CalculatorStore?
    @State private var isCurrencySelectPresented = false

    var body: some View {
        VStack(spacing: 24) {
            // 툴바
            CalculatorToolbar(
                currency: appStore.currencyStore.currentCurrency,
                isOnline: true, // TODO: 네트워크 상태 연결
                lastUpdated: "방금 전", // TODO: 실제 업데이트 시간 연결
                onCurrencyTap: { isCurrencySelectPresented = true },
                onCameraTap: { /* TODO: 카메라 기능 */ },
                onSettingsTap: { /* TODO: 설정 화면 이동 */ }
            )

            if let store {
                // 컨텐츠
                GeometryReader { proxy in
                    let width = proxy.size.width * 0.8
                    let displayHeight = proxy.size.height * 0.23

                    VStack(spacing: 16) {
                        // 디스플레이
                        CalculatorDisplay(
                            model: store.displayModel,
                            isInputLimitExceeded: store.state.isInputLimitExceeded
                        )
                            .frame(height: displayHeight)

                        // 키패드
                        CalculatorKeypad(send: store.send)
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .fullScreenCover(isPresented: $isCurrencySelectPresented) {
            CurrencySelectView()
            .environmentObject(toastManager)
            .toast(Binding(
                get: { toastManager.toast },
                set: { _ in toastManager.dismiss() }
            ))
        }
        .onAppear {
            if store == nil {
                store = CalculatorStore(
                    toastManager: toastManager,
                    currencyStore: appStore.currencyStore
                )
            }
        }
    }
}

#Preview {
    CalculatorView()
        .environmentObject(ToastManager())
        .environmentObject(AppStore())
}
