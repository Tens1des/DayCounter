//
//  ColorPalette.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct ColorPalette {
    static let colors: [(name: String, hex: String)] = [
        ("Blue", "#007AFF"),
        ("Purple", "#5856D6"),
        ("Pink", "#FF2D55"),
        ("Red", "#FF3B30"),
        ("Orange", "#FF9500"),
        ("Yellow", "#FFCC00"),
        ("Green", "#34C759"),
        ("Teal", "#5AC8FA"),
        ("Indigo", "#AF52DE"),
        ("Brown", "#A2845E")
    ]
    
    static let defaultColor = "#007AFF"
}

struct EmojiPicker {
    static let emojis = [
        "📅", "🎯", "💼", "❤️", "💪", "🎓",
        "☕", "💍", "🎂", "🏖️", "✈️", "🎮",
        "⚽", "🏋️", "💰", "🎨", "📚", "🎵",
        "🌟", "🔥", "💎", "🏆", "🎁", "🚀"
    ]
}

struct AvatarPicker {
    static let avatars = [
        "👤", "😊", "🙂", "😎", "🤓", "🧑‍💻",
        "👨‍💼", "👩‍💼", "🧑‍🎓", "👨‍🎨", "👩‍🎤", "🧑‍🚀"
    ]
}

