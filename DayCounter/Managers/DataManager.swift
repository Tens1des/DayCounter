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
    @Published var achievements: [Achievement] = Achievement.allAchievements
    
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
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
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
        AchievementManager.shared.checkAchievements()
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
        AchievementManager.shared.checkAchievements()
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

