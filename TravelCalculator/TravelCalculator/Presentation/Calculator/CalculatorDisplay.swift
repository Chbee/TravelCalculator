//
//  CalculatorDisplay.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/20/26.
//

import SwiftUI

struct CalculatorDisplay: View {
    let state: CalculatorState

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(state.rateDisplay)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.gray600)
                .lineLimit(1)
                .truncationMode(.tail)

            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(state.inputDisplay.currency.rawValue)
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(Color.gray600)

                Text(state.inputDisplay.text)
                    .font(.system(size: 46, weight: .bold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(state.isInputLimitExceeded ? Color.red500 : Color.main900)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            HStack(spacing: 6) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.blue500)

                Text(state.resultDisplay.text + " " + state.resultDisplay.currency.rawValue)
                    .font(.system(size: 26, weight: .semibold))
                    .monospacedDigit()
                    .foregroundStyle(Color.blue500)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .truncationMode(.head)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
