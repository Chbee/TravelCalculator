//
//  CalculatorStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class CalculatorStore {
    private(set) var state = CalculatorState()
    private let reducer = CalculatorReducer()
    private let toastManager: ToastManager

    init(toastManager: ToastManager) {
        self.toastManager = toastManager
    }

    func send(_ intent: CalculatorIntent) {
        reducer.reduce(state: &state, intent: intent)

        if let toast = state.pendingToast {
            toastManager.show(toast)
            state.pendingToast = nil
        }
    }
}
