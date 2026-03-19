//
//  ContentView.swift
//  TravelCalculator
//
//  Created by 손지영 on 12/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CalculatorView()
    }
}

#Preview {
    ContentView()
        .environmentObject(ToastManager())
        .environmentObject(AppStore())
}
