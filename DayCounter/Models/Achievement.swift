//
//  Achievement.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation
import SwiftUI

enum AchievementRarity: String, Codable {
    case common = "COMMON"
    case rare = "RARE"
    case epic = "EPIC"
    case legendary = "LEGENDARY"
    
    var color: Color {
        switch self {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}

struct Achievement: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var icon: String
    var rarity: AchievementRarity
    var points: Int
    var isUnlocked: Bool
    var unlockedDate: Date?
    var progress: Int?
    var maxProgress: Int?
    
    var progressText: String? {
        guard let progress = progress, let maxProgress = maxProgress else { return nil }
        return "\(progress)/\(maxProgress)"
    }
    
    static let allAchievements: [Achievement] = [
        Achievement(
            id: "first_step",
            name: "First Step",
            description: "Create your first counter",
            icon: "🎯",
            rarity: .common,
            points: 10,
            isUnlocked: false
        ),
        Achievement(
            id: "week_warrior",
            name: "Week Warrior",
            description: "Track an event for 7 days",
            icon: "🔥",
            rarity: .common,
            points: 25,
            isUnlocked: false
        ),
        Achievement(
            id: "organizer",
            name: "Organizer",
            description: "Create 5 different counters",
            icon: "⭐",
            rarity: .rare,
            points: 50,
            isUnlocked: false,
            progress: 0,
            maxProgress: 5
        ),
        Achievement(
            id: "month_master",
            name: "Month Master",
            description: "Track an event for 30 days",
            icon: "🏆",
            rarity: .rare,
            points: 75,
            isUnlocked: false,
            progress: 0,
            maxProgress: 30
        ),
        Achievement(
            id: "streak_legend",
            name: "Streak Legend",
            description: "Maintain a 100 day streak",
            icon: "⚡",
            rarity: .epic,
            points: 150,
            isUnlocked: false,
            progress: 0,
            maxProgress: 100
        ),
        Achievement(
            id: "categorizer",
            name: "Categorizer",
            description: "Create 3 custom categories",
            icon: "⭐",
            rarity: .common,
            points: 30,
            isUnlocked: false,
            progress: 0,
            maxProgress: 3
        ),
        Achievement(
            id: "perfectionist",
            name: "Perfectionist",
            description: "Reach 100% on a counter",
            icon: "✅",
            rarity: .rare,
            points: 100,
            isUnlocked: false
        ),
        Achievement(
            id: "year_champion",
            name: "Year Champion",
            description: "Track a count for 365 days",
            icon: "🏅",
            rarity: .legendary,
            points: 500,
            isUnlocked: false,
            progress: 0,
            maxProgress: 365
        )
    ]
}

