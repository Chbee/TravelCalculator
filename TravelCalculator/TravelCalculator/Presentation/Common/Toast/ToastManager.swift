//
//  ToastManager.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import SwiftUI

@MainActor
final class ToastManager: ObservableObject {
    @Published var toast: ToastPayload? = nil

    func show(_ payload: ToastPayload) {
        toast = payload
    }

    func dismiss() {
        toast = nil
    }
}
