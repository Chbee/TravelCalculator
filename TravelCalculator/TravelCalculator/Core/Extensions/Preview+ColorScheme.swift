//
//  Preview+ColorScheme.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/27/26.
//

import SwiftUI

extension View {
    func previewWithColorSchemes() -> some View {
        HStack(spacing: 0) {
            self.preferredColorScheme(.light)
            self.preferredColorScheme(.dark)
        }
    }
}
