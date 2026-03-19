//
//  CalculatorDisplayModel.swift
//  TravelCalculator
//
//  Created by 손지영 on 3/19/26.
//

import Foundation


struct CurrencyAmoutDisplayModel: Equatable {
    let currency: Currency
    let text: String
}

struct CalculatorDisplayModel: Equatable {
    let inputDisplay: CurrencyAmoutDisplayModel
    let resultDisplay: CurrencyAmoutDisplayModel
    let exchangeRate: Double
    
    var rateDisplay: String {
        "1 \(inputDisplay.currency.rawValue) = \(exchangeRate.formatDecimal(maxFractionDigits: 4)) \(resultDisplay.currency.rawValue)"
    }
}
