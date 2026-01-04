//
//  CalculatorReducer.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import Foundation

struct CalculatorReducer {
    func reduce(state: inout CalculatorState, intent: CalculatorIntent) {
        switch intent {
        case .keyPressed(let calculatorButton):
            handleKey(&state, key: calculatorButton)
        }
    }
    
    private func handleKey(_ state: inout CalculatorState, key: CalculatorButton) {
        switch key {
        case .number(let int):
            if state.isEnteringNewNumber {
                state.display = "\(int)"
                state.isEnteringNewNumber = false
            } else {
                state.display = state.display == "0" ? "\(int)" : state.display
                  + "\(int)"
            }
        case .operator(let `operator`):
            state.pendingOperator = `operator`
            state.isEnteringNewNumber = true
        case .decimal:
            guard state.display.contains(".") == false else {
                state.errorMessage = "소수점은 하나만 올 수 있습니다."
                return
            }
            state.display += "."
            state.isEnteringNewNumber = false
        case .equals:
            // 실제 연산 수행
            state.isEnteringNewNumber = true
        case .allClear:
            // TODO: 히스토리 추가 시 전체 초기화(히스토리 포함)로 분리
            state = CalculatorState()
        case .clear:
            // TODO: 히스토리 도입 전까지는 표시값만 초기화하는 로직으로 분리
            state = CalculatorState()
        case .backspace:
            guard state.isEnteringNewNumber == false else { return }
            state.display = String(state.display.dropLast())
            if state.display.isEmpty { state.display = "0" }
        }
    }
}
