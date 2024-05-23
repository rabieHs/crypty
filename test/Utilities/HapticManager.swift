//
//  HapticManager.swift
//  test
//
//  Created by rabie houssaini on 30/5/2024.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(notificationType)
    }
}
