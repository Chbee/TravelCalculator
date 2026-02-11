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
                state.errorMessage = "소수점은 하나만 올 수 있습니다."
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
            return String(prev / cur)
        }
    }
}
