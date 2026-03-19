//
//  CalculatorReducer.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import Foundation

struct CalculatorReducer {
    private let maxInputDigits = 8

    func reduce(state: inout CalculatorState, intent: CalculatorIntent) {
        switch intent {
        case .keyPressed(let calculatorButton):
            handleKey(&state, key: calculatorButton)
        case .resetInputLimitFlag:
            state.isInputLimitExceeded = false
        }
    }

    private func handleKey(_ state: inout CalculatorState, key: CalculatorButton) {
        switch key {
        case .number(let int):
            let next: String
            if state.isEnteringNewNumber || state.display == "0" {
                next = "\(int)"
            } else {
                next = state.display + "\(int)"
            }

            guard digitCount(next) <= maxInputDigits else {
                state.isInputLimitExceeded = true
                state.pendingToast = ToastPayload(
                    style: .warning,
                    title: "입력 제한",
                    message: "최대 8자리까지 입력할 수 있습니다."
                )
                return
            }

            state.display = next
            state.isEnteringNewNumber = false

        case .operator(let `operator`):
            let cur = Double(state.display) ?? 0

            if let prev = state.previousValue,
               let op = state.pendingOperator
            {
                let rs = calculate(prev, op, cur)
                state.display = rs
                state.previousValue = Double(rs)
            } else {
                state.previousValue = cur
            }

            state.pendingOperator = `operator`
            state.isEnteringNewNumber = true
        case .decimal:
            guard state.display.contains(".") == false else {
                state.pendingToast = ToastPayload(
                    style: .warning,
                    title: "주의",
                    message: "소수점은 하나만 입력할 수 있습니다.",
                    duration: 2
                )
                return
            }
            state.display += "."
            state.isEnteringNewNumber = false
        case .equals:
            guard let prev = state.previousValue,
                  let op = state.pendingOperator
            else { return }

            let cur = Double(state.display) ?? 0
            state.display = calculate(prev, op, cur)

            state.previousValue = nil
            state.pendingOperator = nil

            state.isEnteringNewNumber = true
        case .allClear:
            state = CalculatorState()
        case .clear:
            state.display = "0"
            state.isEnteringNewNumber = true
        case .backspace:
            guard state.isEnteringNewNumber == false else { return }
            state.display = String(state.display.dropLast())
            if state.display.isEmpty { state.display = "0" }
        }
    }

    private func calculate(_ prev: Double, _ op: CalculatorButton.Operator, _ cur: Double) -> String {
        switch op {
        case .add:
            return String(prev + cur)
        case .subtract:
            return String(prev - cur)
        case .multiply:
            return String(prev * cur)
        case .divide:
            guard cur != 0 else { return "0" }
            return String(prev / cur)
        }
    }

    private func digitCount(_ value: String) -> Int {
        value.filter(\.isNumber).count
    }
}
