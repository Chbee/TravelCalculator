//
//  CalculatorStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI
import Observation

@MainActor
@Observable // MARK: 추후 마이그레이션 예정
final class CalculatorStore {
    private(set) var state = CalculatorState()
    private let reducer = CalculatorReducer()
    
    private let toastManager: ToastManager
    private let currencyStore: AppCurrencyStore

    init(toastManager: ToastManager, currencyStore: AppCurrencyStore) {
        self.toastManager = toastManager
        self.currencyStore = currencyStore
    }
    
    var fromCurrency: Currency {
        currencyStore.fromCurrency
    }
    
    var toCurrency: Currency {
        currencyStore.toCurrency
    }
    
    var convertedAmount: Double { state.inputAmount * exchangeRate }
    
    var displayModel: CalculatorDisplayModel {
        CalculatorDisplayModel(
            inputDisplay: CurrencyAmoutDisplayModel(
                currency: fromCurrency,
                text: state.inputAmount.formatDecimal(
                    maxFractionDigits: 2
                )
            ),
            resultDisplay: CurrencyAmoutDisplayModel(
                currency: toCurrency,
                text: convertedAmount.formatDecimal(
                    maxFractionDigits: 2
                )
            ),
            exchangeRate: exchangeRate
        )
    }
    
    // FIXME: 테스트용, API 적용 후 삭제 예정
    var exchangeRate: Double {
        switch (fromCurrency, toCurrency) {
        case (.KRW, .USD): return 1.0 / 1320.50
        case (.USD, .KRW): return 1320.50
        case (.KRW, .TWD): return 0.024
        case (.TWD, .KRW): return 41.6
        case (.USD, .TWD): return 31.5
        case (.TWD, .USD): return 0.0317
        default: return 1
        }
    }

    func send(_ intent: CalculatorIntent) {
        reducer.reduce(state: &state, intent: intent)

        if let toast = state.pendingToast {
            toastManager.show(toast)
            state.pendingToast = nil
        }
        
        if state.isInputLimitExceeded {
            Haptic.notification(type: .warning)
            
            Task { @MainActor [weak self] in
                try? await Task.sleep(for: .milliseconds(200))
                self?.send(.resetInputLimitFlag)
            }
        }
    }
}
