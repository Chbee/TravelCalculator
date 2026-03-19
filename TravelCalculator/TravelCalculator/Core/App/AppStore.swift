//
//  AppStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 3/19/26.
//

import Foundation
import Observation

@MainActor
@Observable // MARK: 추후 마이그레이션 예정
final class AppStore: ObservableObject {
    let currencyStore = AppCurrencyStore()
}
