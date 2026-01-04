//
//  CalculatorKeypad.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct CalculatorKeypad: View {
    let state: CalculatorState
    let send: (CalculatorIntent) -> Void
    
    private let buttons: [[CalculatorButton]] = [
        [.allClear, .clear, .backspace, .operator(.divide)],
        [.number(7), .number(8), .number(9), .operator(.multiply)],
        [.number(4), .number(5), .number(6), .operator(.subtract)],
        [.number(1), .number(2), .number(3), .operator(.add)],
        [.number(0), .decimal, .equals]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { button in
                        KeyButton(
                            button: button,
                            send: send
                        )
                    }
                }
            }
        }
    }
    
}

private struct KeyButton: View {
    var button: CalculatorButton
    let send: (CalculatorIntent) -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    private var isLightMode: Bool { colorScheme == .light }
    
    var body: some View {
        Button {
            send(.keyPressed(button))
        } label: {
            getButtonBackgroundColor()
                .frame(width: 48, height: 48)
                .overlay {
                    Text(button.title)
                        .foregroundStyle(getButtonTitleColor())
                }
                .cornerRadius(10)
        }
    }
    
    private func getButtonBackgroundColor() -> Color {
        switch button {
        case .number, .decimal:
            return isLightMode ? .gray100 : .gray700
        case .operator, .allClear, .clear, .backspace:
            return .gray500
        case .equals:
            return .blue500
        }
    }
    
    private func getButtonTitleColor() -> Color {
        switch button {
        case .number, .decimal:
            return isLightMode ? .gray900 : .gray100
        case .operator, .allClear, .clear, .backspace:
            return .gray100
        case .equals:
            return .white
        }
    }
}

#Preview {
    CalculatorKeypad(
        state: CalculatorState(),
        send: { _ in }
    )
}
