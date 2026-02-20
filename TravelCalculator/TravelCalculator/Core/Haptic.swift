//
//  Haptic.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/20/26.
//

import SwiftUI

final class Haptic {
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
