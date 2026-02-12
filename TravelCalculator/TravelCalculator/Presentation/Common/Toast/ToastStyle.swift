//
//  ToastStyle.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/12/26.
//

import SwiftUI

enum ToastStyle {
    case success
    case error
    case warning
    case info
}

extension ToastStyle {
    var tintColor: Color {
        switch self {
        case .success: return Color.green500
        case .error: return Color.red500
        case .warning: return Color.yellow500
        case .info: return Color.main500
        }
    }
    
    var icon: Image {
        switch self {
        case .success: return Image("ToastSuccess")
        case .error: return Image("ToastError")
        case .warning: return Image("ToastWarning")
        case .info: return Image("ToastInfo")
        }
    }
}
