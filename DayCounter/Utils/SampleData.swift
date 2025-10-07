//
//  SampleData.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation

// This file contains sample data for testing and demonstration purposes
// Uncomment the function call in DataManager to populate with sample data

extension DataManager {
    func loadSampleData() {
        // Clear existing data
        counters.removeAll()
        categories = Category.defaultCategories
        
        // Sample counters
        let calendar = Calendar.current
        
        // Summer Vacation (Count Until)
        let summerVacation = Counter(
            name: "Summer Vacation",
            type: .countUntil,
            targetDate: calendar.date(byAdding: .day, value: 42, to: Date())!,
            startDate: calendar.date(byAdding: .day, value: -30, to: Date())!,
            categoryId: categories.first(where: { $0.name == "Personal" })?.id,
            emoji: "🏖️",
            color: "#FF9500",
            note: "Book flights by May",
            showProgress: true,
            isPinned: false
        )
        
        // No Coffee Challenge (Count Since)
        let noCoffee = Counter(
            name: "No Coffee Challenge",
            type: .countSince,
            targetDate: calendar.date(byAdding: .day, value: -28, to: Date())!,
            categoryId: categories.first(where: { $0.name == "Health" })?.id,
            emoji: "☕",
            color: "#A2845E",
            showProgress: false,
            isPinned: false
        )
        
        // Project Launch (Count Until)
        let projectLaunch = Counter(
            name: "Project Launch",
            type: .countUntil,
            targetDate: calendar.date(byAdding: .day, value: 15, to: Date())!,
            startDate: calendar.date(byAdding: .day, value: -45, to: Date())!,
            categoryId: categories.first(where: { $0.name == "Work" })?.id,
            emoji: "🚀",
            color: "#5856D6",
            note: "Final testing phase",
            showProgress: true,
            isPinned: true
        )
        
        // Wedding Anniversary (Count Until)
        let wedding = Counter(
            name: "Wedding Anniversary",
            type: .countUntil,
            targetDate: calendar.date(byAdding: .day, value: 120, to: Date())!,
            startDate: calendar.date(byAdding: .day, value: -245, to: Date())!,
            categoryId: categories.first(where: { $0.name == "Personal" })?.id,
            emoji: "💍",
            color: "#FF2D55",
            note: "Reserve restaurant",
            showProgress: true,
            isPinned: false
        )
        
        // Gym Streak (Count Since)
        let gymStreak = Counter(
            name: "Gym Streak",
            type: .countSince,
            targetDate: calendar.date(byAdding: .day, value: -45, to: Date())!,
            categoryId: categories.first(where: { $0.name == "Health" })?.id,
            emoji: "💪",
            color: "#34C759",
            showProgress: false,
            isPinned: false
        )
        
        // Add counters
        counters = [summerVacation, noCoffee, projectLaunch, wedding, gymStreak]
        
        // Save data
        saveCounters()
        saveCategories()
        
        // Check achievements
        AchievementManager.shared.checkAchievements()
    }
}

