//
//  CalculatorKeypad.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct CalculatorKeypad: View {
    let send: (CalculatorIntent) -> Void
    
    private let buttons: [[CalculatorButton]] = [
        [.allClear, .clear, .backspace, .operator(.divide)],
        [.number(7), .number(8), .number(9), .operator(.multiply)],
        [.number(4), .number(5), .number(6), .operator(.subtract)],
        [.number(1), .number(2), .number(3), .operator(.add)],
        [.number(0), .decimal, .equals]
    ]
    
    private let spacing: CGFloat = 8
    
    var body: some View {
        return GeometryReader { proxy in
            let keypadWidth = proxy.size.width
            let buttonSize = (keypadWidth - spacing*3) / 4
            
            VStack(spacing: spacing) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(row, id: \.self) { button in
                            KeyButton(
                                button: button,
                                buttonSize: buttonSize,
                                spacing: spacing,
                                send: send
                            )
                        }
                    }
                }
            }
            .frame(width: keypadWidth)
            .frame(maxWidth: .infinity)
        }
    }
    
}

private struct KeyButton: View {
    var button: CalculatorButton
    var buttonSize: CGFloat
    var spacing: CGFloat
    let send: (CalculatorIntent) -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    private var isLightMode: Bool { colorScheme == .light }
    
    var body: some View {
        Button {
            send(.keyPressed(button))
        } label: {
            getButtonBackgroundColor()
                .frame(width: button == .number(0) ? buttonSize * 2 + spacing : buttonSize, height: buttonSize)
                .overlay {
                    Text(button.title)
                        .font(.system(size: buttonSize * 0.25))
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
        send: { _ in }
    )
}
