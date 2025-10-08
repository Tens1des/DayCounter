//
//  Counter.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation
import SwiftUI

enum CounterType: String, Codable {
    case countUntil = "Count Until"
    case countSince = "Count Since"
}

struct Counter: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var type: CounterType
    var targetDate: Date
    var startDate: Date // For percentage calculation
    var categoryId: UUID?
    var emoji: String
    var color: String // Hex color
    var note: String?
    var showProgress: Bool
    var isPinned: Bool
    var timeFormat: TimeFormat?
    var createdDate: Date
    
    init(
        name: String,
        type: CounterType,
        targetDate: Date,
        startDate: Date = Date(),
        categoryId: UUID? = nil,
        emoji: String = "📅",
        color: String = "#007AFF",
        note: String? = nil,
        showProgress: Bool = true,
        isPinned: Bool = false,
        timeFormat: TimeFormat? = nil,
        createdDate: Date = Date()
    ) {
        self.name = name
        self.type = type
        self.targetDate = targetDate
        self.startDate = startDate
        self.categoryId = categoryId
        self.emoji = emoji
        self.color = color
        self.note = note
        self.showProgress = showProgress
        self.isPinned = isPinned
        self.timeFormat = timeFormat
        self.createdDate = createdDate
    }
    
    // Calculate days
    var daysCount: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: targetDate)
        return type == .countUntil ? (components.day ?? 0) : abs(components.day ?? 0)
    }
    
    // Calculate progress percentage
    var progressPercentage: Double {
        guard type == .countUntil else { return 0 }
        let calendar = Calendar.current
        let total = calendar.dateComponents([.day], from: startDate, to: targetDate).day ?? 1
        let elapsed = calendar.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return total > 0 ? Double(elapsed) / Double(total) * 100 : 0
    }
    
    // Calculate anniversary (for Count Since)
    var anniversary: (years: Int, months: Int, days: Int)? {
        guard type == .countSince else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: targetDate, to: Date())
        return (components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }
    
    var colorValue: Color {
        Color(hex: color) ?? .blue
    }
    
    // Format time according to TimeFormat
    func formattedTime(using format: TimeFormat) -> String {
        let days = abs(daysCount)
        
        switch format {
        case .days:
            return "\(days)"
        case .weeks:
            let weeks = days / 7
            let remainingDays = days % 7
            if remainingDays > 0 {
                return "\(weeks)w \(remainingDays)d"
            } else {
                return "\(weeks)"
            }
        case .months:
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .day], from: Date(), to: targetDate)
            let months = abs(components.month ?? 0)
            let remainingDays = abs(components.day ?? 0)
            if remainingDays > 0 {
                return "\(months)m \(remainingDays)d"
            } else {
                return "\(months)"
            }
        }
    }
    
    // Get time unit label for format
    func timeUnitLabel(for format: TimeFormat) -> String {
        switch format {
        case .days: return "days"
        case .weeks: return "weeks"
        case .months: return "months"
        }
    }
}

enum TimeFormat: String, Codable, CaseIterable {
    case days = "Days"
    case weeks = "Weeks"
    case months = "Months"
    
    var displayName: String { rawValue }
}

