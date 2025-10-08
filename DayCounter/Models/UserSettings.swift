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


enum DateFormatStyle: String, Codable, CaseIterable, Equatable {
    case ddmmyyyy = "DD.MM.YYYY"
    case mmddyyyy = "MM/DD/YYYY"
    case yyyymmdd = "YYYY-MM-DD"
    
    var displayName: String { rawValue }
    
    var formatString: String {
        switch self {
        case .ddmmyyyy: return "dd.MM.yyyy"
        case .mmddyyyy: return "MM/dd/yyyy"
        case .yyyymmdd: return "yyyy-MM-dd"
        }
    }
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
    var dateFormat: DateFormatStyle
    var defaultTimeFormat: TimeFormat
    var profile: UserProfile
    
    init(
        language: AppLanguage = .english,
        theme: AppTheme = .system,
        textSize: TextSize = .standard,
        dateFormat: DateFormatStyle = .ddmmyyyy,
        defaultTimeFormat: TimeFormat = .days,
        profile: UserProfile = UserProfile()
    ) {
        self.language = language
        self.theme = theme
        self.textSize = textSize
        self.dateFormat = dateFormat
        self.defaultTimeFormat = defaultTimeFormat
        self.profile = profile
    }
}

