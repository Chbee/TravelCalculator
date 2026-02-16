//
//  CalculatorState.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import Foundation

struct CalculatorState: Equatable {
    var display: String = "0" // 화면에 표시되는 현재 입력/결과 문자열
    var selectedCurrency: Currency = .KRW // 선택된 통화
    var formattedDisplay: String {
        Double(display)?.formatCurrency(currencyCode: selectedCurrency.rawValue) ?? display
    }
    var pendingOperator: CalculatorButton.Operator? = nil // 다음 연산에 사용할 연산자(선택된 상태)
    var isEnteringNewNumber: Bool = true // 새 숫자 입력 시작 여부(연산 후 첫 입력 판단)
    var errorMessage: String? = nil // 디버깅/추적용 오류 문자열
    var previousValue: Double? = nil // 연산을 위해 필요
    var isInputLimitExceeded: Bool = false
    var pendingToast: ToastPayload? = nil
}

private extension Double {
    func formatCurrency(currencyCode: String) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .currency
        numberFormat.currencyCode = currencyCode
        return numberFormat.string(from: NSNumber(floatLiteral: self)) ?? ""
    }
}
