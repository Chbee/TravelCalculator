//
//  CalculatorView.swift
//  TravelCalculator
//
//  Created by 손지영 on 1/4/26.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var store = CalculatorStore()
    
    var body: some View {
        VStack(spacing: 16) {
            // 디스플레이
            Text(store.state.display)
                .font(.system(size: 40, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // 키패드
            CalculatorKeypad(
                state: store.state,
                send: store.send
            )
        }
    }
}

#Preview {
    CalculatorView()
}
