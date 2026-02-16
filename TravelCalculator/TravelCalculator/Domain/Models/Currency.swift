//
//  Currency.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/15/26.
//

enum Currency: String, CaseIterable, Identifiable {
    case KRW, USD, TWD
    /// 차후 추가 예정
    
    var id: Self { self }
}

extension Currency {
    var symbol: String {
        switch self {
        case .KRW: return "₩"
        case .USD: return "$"
        case .TWD: return "NT$"
        }
    }
    
    var flag: String {
        switch self {
        case .KRW: return "🇰🇷"
        case .USD: return "🇺🇸"
        case .TWD: return "🇹🇼"
        }
    }

    var countryName: String {
        switch self {
        case .KRW: return "대한민국"
        case .USD: return "미국"
        case .TWD: return "대만"
        }
    }

    var currencyUnit: String { rawValue }

    /// ISO 국가코드(예: "KR", "US", "TW")로 Currency 매칭
    init?(countryCode: String) {
        switch countryCode {
        case "KR": self = .KRW
        case "US": self = .USD
        case "TW": self = .TWD
        default: return nil
        }
    }
}
