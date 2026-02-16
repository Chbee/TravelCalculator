//
//  CurrencySelectView.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/15/26.
//

import SwiftUI

struct CurrencySelectView: View {
    @StateObject private var store = CurrencySelectStore()
    
    private var locationButtonColor: Color {
        store.state.locationPermission ? Color.green500 : Color.main600
    }

    var body: some View {
        ZStack {
            Color.main100
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text("여행지 선택")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.main800)

                    Text("통화 설정을 위해 국가를 선택해주세요")
                        .font(.subheadline)
                        .foregroundStyle(Color.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)

                // MARK: - Location Button
                Button {
                    store.send(.tapCurrentLocation)
                } label: {
                    HStack(spacing: 8) {
                        Image("map-pin")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text("현재 위치로 자동 설정")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(locationButtonColor)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(locationButtonColor, lineWidth: 1.5)
                )
                .padding(.bottom, 24)

                // MARK: - Currency List
                VStack(spacing: 0) {
                    ForEach(store.state.currencies) { currency in
                        Button {
                            store.send(.tapCurrency(currency))
                        } label: {
                            HStack(spacing: 16) {
                                Text(currency.flag)
                                    .font(.system(size: 28))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currency.countryName)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.textPrimary)

                                    Text(currency.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(Color.textTertiary)
                                }

                                Spacer()
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
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    CurrencySelectView()
}
