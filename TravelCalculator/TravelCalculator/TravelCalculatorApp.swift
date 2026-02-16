//
//  TravelCalculatorApp.swift
//  TravelCalculator
//
//  Created by 손지영 on 12/18/25.
//

import SwiftUI

@main
struct TravelCalculatorApp: App {
    @StateObject private var toastManager = ToastManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(toastManager)
                .toast(Binding(
                    get: { toastManager.toast },
                    set: { _ in toastManager.dismiss() }
                ))
        }
    }
}
