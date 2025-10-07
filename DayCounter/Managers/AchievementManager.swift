//
//  AchievementManager.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation

class AchievementManager {
    static let shared = AchievementManager()
    
    private let dataManager = DataManager.shared
    
    func checkAchievements() {
        checkFirstStep()
        checkOrganizer()
        checkWeekWarrior()
        checkMonthMaster()
        checkStreakLegend()
        checkCategorizer()
        checkPerfectionist()
        checkYearChampion()
    }
    
    private func unlockAchievement(id: String) {
        if let index = dataManager.achievements.firstIndex(where: { $0.id == id }) {
            if !dataManager.achievements[index].isUnlocked {
                dataManager.achievements[index].isUnlocked = true
                dataManager.achievements[index].unlockedDate = Date()
                dataManager.saveAchievements()
            }
        }
    }
    
    private func updateProgress(id: String, progress: Int) {
        if let index = dataManager.achievements.firstIndex(where: { $0.id == id }) {
            dataManager.achievements[index].progress = progress
            if let maxProgress = dataManager.achievements[index].maxProgress, progress >= maxProgress {
                unlockAchievement(id: id)
            }
            dataManager.saveAchievements()
        }
    }
    
    private func checkFirstStep() {
        if dataManager.counters.count >= 1 {
            unlockAchievement(id: "first_step")
        }
    }
    
    private func checkOrganizer() {
        let count = dataManager.counters.count
        updateProgress(id: "organizer", progress: min(count, 5))
    }
    
    private func checkWeekWarrior() {
        let hasWeekCounter = dataManager.counters.contains { counter in
            counter.type == .countSince && counter.daysCount >= 7
        }
        if hasWeekCounter {
            unlockAchievement(id: "week_warrior")
        }
    }
    
    private func checkMonthMaster() {
        if let maxDays = dataManager.counters.filter({ $0.type == .countSince }).map({ $0.daysCount }).max() {
            updateProgress(id: "month_master", progress: min(maxDays, 30))
        }
    }
    
    private func checkStreakLegend() {
        if let maxDays = dataManager.counters.filter({ $0.type == .countSince }).map({ $0.daysCount }).max() {
            updateProgress(id: "streak_legend", progress: min(maxDays, 100))
        }
    }
    
    private func checkCategorizer() {
        let customCategories = dataManager.categories.filter { category in
            !Category.defaultCategories.contains { $0.name == category.name }
        }
        updateProgress(id: "categorizer", progress: min(customCategories.count, 3))
    }
    
    private func checkPerfectionist() {
        let hasPerfect = dataManager.counters.contains { counter in
            counter.type == .countUntil && counter.progressPercentage >= 100
        }
        if hasPerfect {
            unlockAchievement(id: "perfectionist")
        }
    }
    
    private func checkYearChampion() {
        if let maxDays = dataManager.counters.map({ $0.daysCount }).max() {
            updateProgress(id: "year_champion", progress: min(maxDays, 365))
        }
    }
}

