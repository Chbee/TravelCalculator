//
//  CalculatorState.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import Foundation

typealias CurrencyDisplay = (currency: Currency, text: String)

struct CalculatorState: Equatable {
    var display: String = "0" // 화면에 표시되는 현재 입력/결과 문자열
    var selectedCurrency: Currency = .KRW // 선택된 통화
    
    var inputAmount: Double { Double(display) ?? 0 }
    var targetCurrency: Currency { selectedCurrency == .KRW ? .USD : .KRW }
    
    var convertedAmount: Double { inputAmount * exchangeRate }
    
    var inputDisplay: CurrencyDisplay {
        CurrencyDisplay(currency: selectedCurrency, text: inputAmount.formatDecimal(maxFractionDigits: 2))
    }
    
    var resultDisplay: CurrencyDisplay {
        CurrencyDisplay(currency: targetCurrency, text: convertedAmount.formatDecimal(maxFractionDigits: 2))
    }
    
    var rateDisplay: String {
        "1 \(inputDisplay.currency.rawValue) = \(exchangeRate.formatDecimal(maxFractionDigits: 4)) \(resultDisplay.currency.rawValue)"
    }
    
    var pendingOperator: CalculatorButton.Operator? = nil // 다음 연산에 사용할 연산자(선택된 상태)
    var isEnteringNewNumber: Bool = true // 새 숫자 입력 시작 여부(연산 후 첫 입력 판단)
    var previousValue: Double? = nil // 연산을 위해 필요
    var isInputLimitExceeded: Bool = false
    var pendingToast: ToastPayload? = nil
    
    // FIXME: 테스트용, API 적용 후 삭제 예정
    var exchangeRate: Double {
        switch (selectedCurrency, targetCurrency) {
        case (.KRW, .USD): return 1.0 / 1320.50
        case (.USD, .KRW): return 1320.50
        case (.KRW, .TWD): return 0.024
        case (.TWD, .KRW): return 41.6
        case (.USD, .TWD): return 31.5
        case (.TWD, .USD): return 0.0317
        default: return 1
        }
    }
}

private extension Double {
    func formatDecimal(maxFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
