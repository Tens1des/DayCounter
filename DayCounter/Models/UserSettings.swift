//
//  UserSettings.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation

enum AppLanguage: String, Codable, CaseIterable, Equatable {
    case english = "English"
    case russian = "Русский"
    
    var displayName: String { rawValue }
    
    var locale: Locale {
        switch self {
        case .english: return Locale(identifier: "en")
        case .russian: return Locale(identifier: "ru")
        }
    }
}

enum AppTheme: String, Codable, CaseIterable, Equatable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var displayName: String { rawValue }
}


enum TextSize: String, Codable, CaseIterable, Equatable {
    case small = "Small"
    case standard = "Standard"
    case large = "Large"
    
    var displayName: String { rawValue }
    
    var scaleFactor: CGFloat {
        switch self {
        case .small: return 0.9
        case .standard: return 1.0
        case .large: return 1.2
        }
    }
}

struct UserProfile: Codable, Equatable {
    var name: String
    var avatarEmoji: String
    
    init(name: String = "User", avatarEmoji: String = "👤") {
        self.name = name
        self.avatarEmoji = avatarEmoji
    }
}

struct UserSettings: Codable, Equatable {
    var language: AppLanguage
    var theme: AppTheme
    var textSize: TextSize
    var profile: UserProfile
    
    init(
        language: AppLanguage = .english,
        theme: AppTheme = .system,
        textSize: TextSize = .standard,
        profile: UserProfile = UserProfile()
    ) {
        self.language = language
        self.theme = theme
        self.textSize = textSize
        self.profile = profile
    }
}

