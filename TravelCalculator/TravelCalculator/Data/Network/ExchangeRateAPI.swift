//
//  ExchangeRateAPI.swift
//  TravelCalculator
//

import Foundation

final class ExchangeRateAPI {
    private let baseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"
    private let apiKey: String
    private let cacheFileName = "exchange_rates_cache.json"
    private let cacheValidityHours: Int = 24

    init(apiKey: String = "") {
        self.apiKey = apiKey
    }

    // MARK: - Public

    /// 환율 데이터 조회 (캐시 우선, 만료시 API 호출)
    func getExchangeRates() async throws -> ExchangeRateResponse {
        // 1. 캐시 확인
        if let cached = loadCache(), cached.isValid {
            return cached
        }

        // 2. API 호출
        do {
            let rates = try await fetchFromAPI()
            let response = ExchangeRateResponse(
                rates: rates,
                fetchedAt: Date(),
                validUntil: Date().addingTimeInterval(TimeInterval(cacheValidityHours * 3600))
            )
            saveCache(response)
            return response
        } catch {
            // 3. API 실패시 만료된 캐시라도 반환
            if let expiredCache = loadCache() {
                return expiredCache
            }
            throw error
        }
    }

    /// 강제 새로고침
    func refresh() async throws -> ExchangeRateResponse {
        let rates = try await fetchFromAPI()
        let response = ExchangeRateResponse(
            rates: rates,
            fetchedAt: Date(),
            validUntil: Date().addingTimeInterval(TimeInterval(cacheValidityHours * 3600))
        )
        saveCache(response)
        return response
    }

    // MARK: - API

    private func fetchFromAPI() async throws -> [ExchangeRate] {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "authkey", value: apiKey),
            URLQueryItem(name: "searchdate", value: todayString()),
            URLQueryItem(name: "data", value: "AP01")
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }

        let dtos = try JSONDecoder().decode([ExchangeRateDTO].self, from: data)
        return dtos.compactMap { $0.toExchangeRate() }
    }

    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }

    // MARK: - Cache

    private var cacheURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheFileName)
    }

    private func loadCache() -> ExchangeRateResponse? {
        guard let data = try? Data(contentsOf: cacheURL) else { return nil }
        return try? JSONDecoder().decode(ExchangeRateResponse.self, from: data)
    }

    private func saveCache(_ response: ExchangeRateResponse) {
        guard let data = try? JSONEncoder().encode(response) else { return }
        try? data.write(to: cacheURL)
    }

    // MARK: - Error

    enum APIError: LocalizedError {
        case invalidURL
        case serverError

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "잘못된 URL입니다."
            case .serverError: return "서버 오류가 발생했습니다."
            }
        }
    }
}

// MARK: - Models

struct ExchangeRateResponse: Codable {
    let rates: [ExchangeRate]
    let fetchedAt: Date
    let validUntil: Date

    var isValid: Bool {
        Date() < validUntil
    }
}

struct ExchangeRate: Codable, Identifiable {
    var id: String { currencyCode }
    let currencyCode: String  // USD, JPY
    let currencyName: String  // 미국 달러
    let rate: Decimal         // 1 외화 = N 원
}

struct ExchangeRateDTO: Codable {
    let result: Int
    let curUnit: String
    let curNm: String
    let dealBasR: String

    enum CodingKeys: String, CodingKey {
        case result
        case curUnit = "cur_unit"
        case curNm = "cur_nm"
        case dealBasR = "deal_bas_r"
    }

    func toExchangeRate() -> ExchangeRate? {
        guard result == 1 else { return nil }

        let cleanedRate = dealBasR.replacingOccurrences(of: ",", with: "")
        guard var rate = Decimal(string: cleanedRate) else { return nil }

        var code = curUnit
        if curUnit.contains("(100)") {
            code = curUnit.replacingOccurrences(of: "(100)", with: "")
            rate = rate / 100
        }

        return ExchangeRate(currencyCode: code, currencyName: curNm, rate: rate)
    }
}
