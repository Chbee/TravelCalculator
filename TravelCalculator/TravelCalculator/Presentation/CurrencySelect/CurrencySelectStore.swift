//
//  CurrencySelectStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import SwiftUI
import Observation

@MainActor
@Observable // MARK: 추후 마이그레이션 예정
final class CurrencySelectStore {
    private(set) var state = CurrencySelectState()
    private let permissionService: PermissionService
    private let locationService: LocationServiceProtocol
    private let toastManager: ToastManager
    private let currencyStore: AppCurrencyStore

    init(
        toastManager: ToastManager,
        currencyStore: AppCurrencyStore,
        permissionService: PermissionService = LocationPermissionService(),
        locationService: LocationServiceProtocol = LocationService()
    ) {
        self.toastManager = toastManager
        self.currencyStore = currencyStore
        self.permissionService = permissionService
        self.locationService = locationService
    }
    
    var selectedCurrency: Currency {
        currencyStore.selectedCurrency
    }

    func send(_ intent: CurrencySelectIntent) {
        switch intent {
        case .onAppear:
            state.locationPermission = permissionService.status()
        case .tapCurrentLocation:
            handleLocationRequest()
        case .tapCurrency(let currency):
            currencyStore.selectCurrency(currency)
        }
    }

    // MARK: - Side Effects

    private func handleLocationRequest() {
        guard !state.isSearchingLocation else { return }

        switch state.locationPermission {
        case .granted:
            searchLocation()
        case .notDetermined:
            requestPermissionThenSearch()
        case .denied:
            toastManager.show(ToastPayload(
                style: .warning,
                title: "위치 권한 필요",
                message: "설정에서 위치 권한을 허용해주세요"
            ))
        }
    }

    private func requestPermissionThenSearch() {
        Task {
            let result = await permissionService.request()
            state.locationPermission = result
            if result == .granted {
                searchLocation()
            }
        }
    }

    private func searchLocation() {
        state.isSearchingLocation = true

        Task {
            do {
                let countryCode = try await locationService.fetchCountryCode()

                if let currency = Currency(countryCode: countryCode) {
                    currencyStore.selectCurrency(currency)
                    toastManager.show(ToastPayload(
                        style: .success,
                        title: "위치 확인 완료",
                        message: "\(currency.countryName)(\(currency.rawValue))이 선택되었습니다"
                    ))
                } else {
                    toastManager.show(ToastPayload(
                        style: .warning,
                        title: "지원하지 않는 지역",
                        message: "현재 위치의 통화는 지원하지 않습니다"
                    ))
                }
            } catch {
                toastManager.show(ToastPayload(
                    style: .error,
                    title: "위치 조회 실패",
                    message: "위치를 가져올 수 없습니다. 다시 시도해주세요"
                ))
            }

            state.isSearchingLocation = false
        }
    }
}
