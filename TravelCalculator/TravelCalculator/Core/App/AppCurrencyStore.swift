//
//  AppCurrencyStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 3/19/26.
//

import Foundation
import Observation

enum ConversionDirection {
    case selectedToKRW
    case krwToSelected
}

@MainActor
@Observable // MARK: 추후 마이그레이션 예정
final class AppCurrencyStore {
    var selectedCurrency: Currency = .KRW
    var conversionDirection: ConversionDirection = .selectedToKRW
    
    var fromCurrency: Currency {
        if selectedCurrency == .KRW { return .KRW }
        switch conversionDirection {
        case .selectedToKRW: return selectedCurrency
        case .krwToSelected: return .KRW
        }
    }
    
    var toCurrency: Currency {
        if selectedCurrency == .KRW { return .KRW }
        switch conversionDirection {
        case .selectedToKRW: return .KRW
        case .krwToSelected: return selectedCurrency
        }
    }
    
    func selectCurrency(_ currency: Currency) {
        selectedCurrency = currency
        
        conversionDirection = .selectedToKRW
    }
    
    func toggleConversionDirection() {
        guard selectedCurrency != .KRW else { return }
        
        switch conversionDirection {
        case .selectedToKRW: conversionDirection = .krwToSelected
        case .krwToSelected: conversionDirection = .selectedToKRW
        }
    }
}
