//
//  CalculatorStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

@MainActor
final class CalculatorStore: ObservableObject {
    @Published private(set) var state = CalculatorState()
    private let reducer = CalculatorReducer()

    func send(_ intent: CalculatorIntent) {
        reducer.reduce(state: &state, intent: intent)
    }
}
