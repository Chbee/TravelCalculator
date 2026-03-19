//
//  CurrencySelectIntent.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import Foundation

enum CurrencySelectIntent: Equatable {
    case onAppear
    case tapCurrentLocation
    case tapCurrency(Currency)
}
