//
//  MoodModels.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import Foundation
import SwiftUI

/// Represents the different mood levels a user can select
enum MoodLevel: Int16, CaseIterable, Identifiable {
    case veryBad = 1
    case bad = 2
    case neutral = 3
    case good = 4
    case veryGood = 5
    
    var id: Int16 { self.rawValue }
    
    /// Returns the emoji representation of the mood level
    var emoji: String {
        switch self {
        case .veryBad: return "😢"
        case .bad: return "😕"
        case .neutral: return "😐"
        case .good: return "🙂"
        case .veryGood: return "😄"
        }
    }
    
    /// Returns the text description of the mood level
    var description: String {
        switch self {
        case .veryBad: return "Very Bad"
        case .bad: return "Bad"
        case .neutral: return "Neutral"
        case .good: return "Good"
        case .veryGood: return "Very Good"
        }
    }
    
    /// Returns the color associated with the mood level
    var color: Color {
        switch self {
        case .veryBad: return Color.red
        case .bad: return Color.orange
        case .neutral: return Color.yellow
        case .good: return Color.green
        case .veryGood: return Color.blue
        }
    }
}

/// Represents the different contextual factors that might affect mood
enum ContextFactor: String, CaseIterable, Identifiable {
    case sleep = "Sleep"
    case exercise = "Exercise"
    case nutrition = "Nutrition"
    case socialInteraction = "Social Interaction"
    case work = "Work"
    case stress = "Stress"
    case weather = "Weather"
    case health = "Health"
    
    var id: String { self.rawValue }
    
    /// Returns the icon name for the context factor
    var iconName: String {
        switch self {
        case .sleep: return "bed.double.fill"
        case .exercise: return "figure.run"
        case .nutrition: return "fork.knife"
        case .socialInteraction: return "person.2.fill"
        case .work: return "briefcase.fill"
        case .stress: return "exclamationmark.triangle.fill"
        case .weather: return "cloud.sun.fill"
        case .health: return "heart.fill"
        }
    }
}
