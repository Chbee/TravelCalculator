//
//  ToastPayload.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/12/26.
//

import Foundation

struct ToastPayload: Equatable, Identifiable {
    let id = UUID()
    var style: ToastStyle
    var title: String
    var message: String
    var duration: TimeInterval = 3
}
