//
//  CalculatorIntent.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import Foundation


enum CalculatorIntent: Equatable {
    case keyPressed(CalculatorButton)
    case resetInputLimitFlag
}


enum CalculatorButton: Hashable {
    case number(Int)
    case `operator`(Operator)
    case decimal
    case equals
    case allClear      // AC: 전체 초기화
    case clear         // C: 현재 입력만 지우기
    case backspace

    enum Operator: String {
        case add = "+"
        case subtract = "-"
        case multiply = "×"
        case divide = "÷"
    }

    // MARK: - UI Properties

    var title: String {
        switch self {
        case .number(let n): return "\(n)"
        case .operator(let op): return op.rawValue
        case .decimal: return "."
        case .equals: return "="
        case .allClear: return "AC"
        case .clear: return "C"
        case .backspace: return "←"
        }
    }
}
