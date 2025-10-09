//
//  DataManager.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var counters: [Counter] = []
    @Published var categories: [Category] = []
    @Published var settings: UserSettings = UserSettings()
    @Published var achievements: [Achievement] = []
    
    private let countersKey = "counters"
    private let categoriesKey = "categories"
    private let settingsKey = "settings"
    private let achievementsKey = "achievements"
    
    init() {
        loadData()
        
        // Load sample data if no counters exist
        if counters.isEmpty {
            loadSampleData()
        }
    }
    
    // MARK: - Load Data
    func loadData() {
        loadCounters()
        loadCategories()
        loadSettings()
        loadAchievements()
    }
    
    private func loadCounters() {
        if let data = UserDefaults.standard.data(forKey: countersKey),
           let decoded = try? JSONDecoder().decode([Counter].self, from: data) {
            counters = decoded
        }
    }
    
    private func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let decoded = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decoded
        } else {
            categories = Category.defaultCategories
            saveCategories()
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            settings = decoded
        } else {
            settings = UserSettings()
            saveSettings()
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = savedAchievements
        } else {
            // Если ничего не сохранено, создаём достижения по умолчанию
            achievements = createDefaultAchievements()
            saveAchievements()
        }
    }
    
    private func createDefaultAchievements() -> [Achievement] {
        return [
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
    
    // MARK: - Save Data
    func saveCounters() {
        if let encoded = try? JSONEncoder().encode(counters) {
            UserDefaults.standard.set(encoded, forKey: countersKey)
        }
    }
    
    func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    // MARK: - Counter Operations
    func addCounter(_ counter: Counter) {
        counters.append(counter)
        saveCounters()
    }
    
    func updateCounter(_ counter: Counter) {
        if let index = counters.firstIndex(where: { $0.id == counter.id }) {
            counters[index] = counter
            saveCounters()
        }
    }
    
    func deleteCounter(_ counter: Counter) {
        counters.removeAll { $0.id == counter.id }
        saveCounters()
    }
    
    func togglePin(_ counter: Counter) {
        if let index = counters.firstIndex(where: { $0.id == counter.id }) {
            counters[index].isPinned.toggle()
            saveCounters()
        }
    }
    
    // MARK: - Category Operations
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        // Remove category from counters
        for i in 0..<counters.count {
            if counters[i].categoryId == category.id {
                counters[i].categoryId = nil
            }
        }
        saveCounters()
        
        categories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    // MARK: - Settings Operations
    func updateSettings(_ newSettings: UserSettings) {
        settings = newSettings
        saveSettings()
    }
    
    // MARK: - Helpers
    func getCategory(id: UUID?) -> Category? {
        guard let id = id else { return nil }
        return categories.first { $0.id == id }
    }
    
    var pinnedCounters: [Counter] {
        counters.filter { $0.isPinned }
    }
    
    var unpinnedCounters: [Counter] {
        counters.filter { !$0.isPinned }
    }
}

