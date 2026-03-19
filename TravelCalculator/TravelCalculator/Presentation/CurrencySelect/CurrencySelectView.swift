//
//  CurrencySelectView.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/15/26.
//

import SwiftUI

struct CurrencySelectView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager
    @EnvironmentObject private var appStore: AppStore
    
    @State private var store: CurrencySelectStore?
    
    private var locationButtonColor: Color {
        guard let store else { return Color.gray500 }
        switch store.state.locationPermission {
        case .granted: return Color.green500
        default: return Color.gray500
        }
    }
    
    var body: some View {
        ZStack {
            Color.main100
                .ignoresSafeArea()

            if let store {
                VStack(spacing: 0) {
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("여행지 선택")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.main800)

                        Text("통화 설정을 위해 국가를 선택해주세요")
                            .font(.subheadline)
                            .foregroundStyle(Color.gray600)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)

                    // MARK: - Location Button
                    Button {
                        store.send(.tapCurrentLocation)
                    } label: {
                        HStack(spacing: 8) {
                            if store.state.isSearchingLocation {
                                ProgressView()
                                    .tint(locationButtonColor)
                            } else {
                                Image("map-pin")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            Text(store.state.isSearchingLocation ? "위치를 찾고있어요" : "현재 위치로 자동 설정")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(locationButtonColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .frame(minWidth: 220)
                    }
                    .disabled(store.state.isSearchingLocation)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(locationButtonColor, lineWidth: 1.5)
                    )
                    .animation(.easeInOut(duration: 0.2), value: store.state.isSearchingLocation)
                    .padding(.bottom, 24)

                    // MARK: - Currency List
                    VStack(spacing: 0) {
                        ForEach(store.state.currencies) { currency in
                            Button {
                                store.send(.tapCurrency(currency))
                                dismiss()
                            } label: {
                                HStack(spacing: 16) {
                                    Text(currency.flag)
                                        .font(.system(size: 28))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(currency.countryName)
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color.main900)

                                        Text(currency.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(Color.gray400)
                                    }

                                    Spacer()
                                    
                                    if store.selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(Color.green500)
                                    }
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                            }

                            if currency != Currency.allCases.last {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(16)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.main800)
                    .padding(10)
                    .background(Color.main100.opacity(0.9))
                    .clipShape(Circle())
            }
            .padding(16)
        }
        .onAppear {
            if store == nil {
                store = CurrencySelectStore(
                    toastManager: toastManager,
                    currencyStore: appStore.currencyStore
                )
            }
            store?.send(.onAppear)
        }
    }
}

#Preview {
    CurrencySelectView()
        .environmentObject(ToastManager())
        .environmentObject(AppStore())
}
