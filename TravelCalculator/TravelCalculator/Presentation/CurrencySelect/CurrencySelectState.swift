//
//  CurrencySelectState.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import Foundation

struct CurrencySelectState: Equatable {
    var currencies: [Currency] = Currency.allCases
    var selectedCurrency: Currency? = nil
    var locationPermission: Bool = false
    var errorMessage: String? = nil
}
