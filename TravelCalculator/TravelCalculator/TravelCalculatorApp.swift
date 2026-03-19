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
    @StateObject private var appStore = AppStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(toastManager)
                .environmentObject(appStore)
                .toast(Binding(
                    get: { toastManager.toast },
                    set: { _ in toastManager.dismiss() }
                ))
        }
    }
}
