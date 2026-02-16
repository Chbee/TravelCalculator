//
//  CalculatorToolbar.swift
//  TravelCalculator
//
//  Created by Claude on 2/16/26.
//

import SwiftUI

struct CalculatorToolbar: View {
    let currency: Currency
    let isOnline: Bool
    let lastUpdated: String
    let onCurrencyTap: () -> Void
    let onCameraTap: () -> Void
    let onSettingsTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // MARK: - Currency Button
            Button(action: onCurrencyTap) {
                HStack(spacing: 6) {
                    Text(currency.flag)
                        .font(.system(size: 16))
                    Text(currency.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white500)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.main300)
                .clipShape(Capsule())
            }

            // MARK: - Online Status
            VStack(spacing: 2) {
                HStack(spacing: 4) {
                    Image(isOnline ? "wifi" : "wifi-off")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                    Text(isOnline ? "온라인" : "오프라인")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(Color.main800)
                Text(lastUpdated)
                    .font(.system(size: 9))
                    .foregroundStyle(Color.main600)
            }

            Spacer()

            // MARK: - Action Icons
            HStack(spacing: 16) {
                Button(action: onCameraTap) {
                    Image("camera")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.main800)
                }

                Button(action: onSettingsTap) {
                    Image("settings")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.main800)
                }
            }
            .foregroundStyle(Color.gray300)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.gray200)
    }
}

#Preview {
    ZStack {
        Color.gray100.ignoresSafeArea()
        CalculatorToolbar(
            currency: .KRW,
            isOnline: true,
            lastUpdated: "방금 전",
            onCurrencyTap: {},
            onCameraTap: {},
            onSettingsTap: {}
        )
        .padding()
    }
}
