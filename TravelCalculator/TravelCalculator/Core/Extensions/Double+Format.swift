//
//  Double+Format.swift
//  TravelCalculator
//
//  Created by 손지영 on 3/19/26.
//

import Foundation

extension Double {
    func formatDecimal(maxFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
