//
//  CalculatorView.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject private var toastManager: ToastManager
    @State private var store: CalculatorStore?
    @State private var isCurrencySelectPresented = false

    var body: some View {
        VStack(spacing: 24) {
            // 툴바
            CalculatorToolbar(
                currency: store?.state.selectedCurrency ?? .KRW,
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
            }
        }
        .fullScreenCover(isPresented: $isCurrencySelectPresented) {
            CurrencySelectView(
                initialCurrency: store?.state.selectedCurrency ?? .KRW,
                onSelect: { currency in
                    store?.send(.selectCurrency(currency))
                }
            )
            .environmentObject(toastManager)
            .toast(Binding(
                get: { toastManager.toast },
                set: { _ in toastManager.dismiss() }
            ))
        }
        .onAppear {
            if store == nil {
                store = CalculatorStore(toastManager: toastManager)
            }
        }
        .onChange(of: store?.state.isInputLimitExceeded ?? false) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    store?.send(.resetInputLimitFlag)
                }
            }
        }
    }
}

#Preview {
    CalculatorView()
        .environmentObject(ToastManager())
}
