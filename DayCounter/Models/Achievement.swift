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
        ),
        // New Achievements
        Achievement(
            id: "emoji_master",
            name: "Emoji Master",
            description: "Add emoji to 5 events",
            icon: "😎",
            rarity: .common,
            points: 20,
            isUnlocked: false,
            progress: 0,
            maxProgress: 5
        ),
        Achievement(
            id: "colorful_life",
            name: "Colorful Life",
            description: "Assign different colors to 3 events",
            icon: "🎨",
            rarity: .common,
            points: 15,
            isUnlocked: false,
            progress: 0,
            maxProgress: 3
        ),
        Achievement(
            id: "pin_master",
            name: "Pin Master",
            description: "Pin 3 important events",
            icon: "📌",
            rarity: .rare,
            points: 40,
            isUnlocked: false,
            progress: 0,
            maxProgress: 3
        ),
        Achievement(
            id: "note_keeper",
            name: "Note Keeper",
            description: "Add notes to 5 events",
            icon: "📝",
            rarity: .common,
            points: 25,
            isUnlocked: false,
            progress: 0,
            maxProgress: 5
        ),
        Achievement(
            id: "time_traveler",
            name: "Time Traveler",
            description: "Create 10 different counters",
            icon: "⏰",
            rarity: .epic,
            points: 100,
            isUnlocked: false,
            progress: 0,
            maxProgress: 10
        ),
        Achievement(
            id: "dedication",
            name: "Dedication",
            description: "Use the app for 7 consecutive days",
            icon: "💎",
            rarity: .rare,
            points: 60,
            isUnlocked: false,
            progress: 0,
            maxProgress: 7
        ),
        Achievement(
            id: "milestone_hunter",
            name: "Milestone Hunter",
            description: "Reach 5 event milestones",
            icon: "🎯",
            rarity: .epic,
            points: 120,
            isUnlocked: false,
            progress: 0,
            maxProgress: 5
        ),
        Achievement(
            id: "ultimate_tracker",
            name: "Ultimate Tracker",
            description: "Have 20 active counters",
            icon: "👑",
            rarity: .legendary,
            points: 300,
            isUnlocked: false,
            progress: 0,
            maxProgress: 20
        )
    ]
}

