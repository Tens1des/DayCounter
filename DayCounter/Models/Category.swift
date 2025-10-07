//
//  Category.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var emoji: String
    var color: String // Hex color
    
    init(name: String, emoji: String = "📁", color: String = "#007AFF") {
        self.name = name
        self.emoji = emoji
        self.color = color
    }
    
    var colorValue: Color {
        Color(hex: color) ?? .blue
    }
    
    static let defaultCategories: [Category] = [
        Category(name: "Personal", emoji: "👤", color: "#FF2D55"),
        Category(name: "Work", emoji: "💼", color: "#5856D6"),
        Category(name: "Health", emoji: "❤️", color: "#FF9500"),
        Category(name: "Learning", emoji: "📚", color: "#34C759")
    ]
}

