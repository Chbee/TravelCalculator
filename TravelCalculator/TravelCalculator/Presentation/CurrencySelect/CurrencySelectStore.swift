//
//  CurrencySelectStore.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import SwiftUI

@MainActor
final class CurrencySelectStore: ObservableObject {
    @Published private(set) var state = CurrencySelectState()
    private let permissionService: PermissionService

    init(permissionService: PermissionService = LocationPermissionService()) {
        self.permissionService = permissionService
    }

    func send(_ intent: CurrencySelectIntent) {
        switch intent {
        case .onAppear:
            state.locationPermission = permissionService.status() == .granted
        case .tapCurrentLocation:
            handleLocationRequest()
        case .tapCurrency(let currency):
            state.selectedCurrency = currency
        }
    }

    // MARK: - Side Effects

    private func handleLocationRequest() {
        let current = permissionService.status()

        if current == .granted {
            // TODO: 위치 정보로 통화 조회
        } else {
            Task {
                let result = await permissionService.request()
                state.locationPermission = result == .granted
            }
        }
    }
}
