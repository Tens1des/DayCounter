//
//  Localization.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import Foundation

struct LocalizedStrings {
    static let shared = LocalizedStrings()
    
    private init() {}
    
    // MARK: - Main Navigation
    var home: String {
        switch DataManager.shared.settings.language {
        case .english: return "Home"
        case .russian: return "Главная"
        }
    }
    
    var achievements: String {
        switch DataManager.shared.settings.language {
        case .english: return "Achievements"
        case .russian: return "Достижения"
        }
    }
    
    var settings: String {
        switch DataManager.shared.settings.language {
        case .english: return "Settings"
        case .russian: return "Настройки"
        }
    }
    
    // MARK: - Home Screen
    var dayCounter: String {
        switch DataManager.shared.settings.language {
        case .english: return "DayCounter"
        case .russian: return "Счётчик дней"
        }
    }
    
    var noCountersYet: String {
        switch DataManager.shared.settings.language {
        case .english: return "No Counters Yet"
        case .russian: return "Пока нет счётчиков"
        }
    }
    
    var createFirstCounter: String {
        switch DataManager.shared.settings.language {
        case .english: return "Create your first counter to start tracking your moments"
        case .russian: return "Создайте свой первый счётчик, чтобы начать отслеживать важные моменты"
        }
    }
    
    var createFirstCounterButton: String {
        switch DataManager.shared.settings.language {
        case .english: return "Create First Counter"
        case .russian: return "Создать первый счётчик"
        }
    }
    
    var search: String {
        switch DataManager.shared.settings.language {
        case .english: return "Search"
        case .russian: return "Поиск"
        }
    }
    
    var all: String {
        switch DataManager.shared.settings.language {
        case .english: return "All"
        case .russian: return "Все"
        }
    }
    
    var pinned: String {
        switch DataManager.shared.settings.language {
        case .english: return "PINNED"
        case .russian: return "ЗАКРЕПЛЁННЫЕ"
        }
    }
    
    var allCounters: String {
        switch DataManager.shared.settings.language {
        case .english: return "ALL COUNTERS"
        case .russian: return "ВСЕ СЧЁТЧИКИ"
        }
    }
    
    var days: String {
        switch DataManager.shared.settings.language {
        case .english: return "days"
        case .russian: return "дней"
        }
    }
    
    var daysRemaining: String {
        switch DataManager.shared.settings.language {
        case .english: return "days remaining"
        case .russian: return "дней осталось"
        }
    }
    
    var daysPassed: String {
        switch DataManager.shared.settings.language {
        case .english: return "days passed"
        case .russian: return "дней прошло"
        }
    }
    
    var progress: String {
        switch DataManager.shared.settings.language {
        case .english: return "Progress"
        case .russian: return "Прогресс"
        }
    }
    
    // MARK: - Counter Detail
    var notes: String {
        switch DataManager.shared.settings.language {
        case .english: return "Notes"
        case .russian: return "Заметки"
        }
    }
    
    var years: String {
        switch DataManager.shared.settings.language {
        case .english: return "years"
        case .russian: return "лет"
        }
    }
    
    var months: String {
        switch DataManager.shared.settings.language {
        case .english: return "months"
        case .russian: return "месяцев"
        }
    }
    
    // MARK: - Add/Edit Counter
    var newCounter: String {
        switch DataManager.shared.settings.language {
        case .english: return "New Counter"
        case .russian: return "Новый счётчик"
        }
    }
    
    var editCounter: String {
        switch DataManager.shared.settings.language {
        case .english: return "Edit Counter"
        case .russian: return "Редактировать счётчик"
        }
    }
    
    var eventName: String {
        switch DataManager.shared.settings.language {
        case .english: return "Event Name *"
        case .russian: return "Название события *"
        }
    }
    
    var counterType: String {
        switch DataManager.shared.settings.language {
        case .english: return "Counter Type *"
        case .russian: return "Тип счётчика *"
        }
    }
    
    var countUntil: String {
        switch DataManager.shared.settings.language {
        case .english: return "Count Until"
        case .russian: return "До события"
        }
    }
    
    var countSince: String {
        switch DataManager.shared.settings.language {
        case .english: return "Count Since"
        case .russian: return "С момента"
        }
    }
    
    var eventDate: String {
        switch DataManager.shared.settings.language {
        case .english: return "Event Date *"
        case .russian: return "Дата события *"
        }
    }
    
    var category: String {
        switch DataManager.shared.settings.language {
        case .english: return "Category"
        case .russian: return "Категория"
        }
    }
    
    var emoji: String {
        switch DataManager.shared.settings.language {
        case .english: return "Emoji"
        case .russian: return "Эмодзи"
        }
    }
    
    var accentColor: String {
        switch DataManager.shared.settings.language {
        case .english: return "Accent Color"
        case .russian: return "Акцентный цвет"
        }
    }
    
    var note: String {
        switch DataManager.shared.settings.language {
        case .english: return "Note (Optional)"
        case .russian: return "Заметка (необязательно)"
        }
    }
    
    var options: String {
        switch DataManager.shared.settings.language {
        case .english: return "Options"
        case .russian: return "Опции"
        }
    }
    
    var showProgress: String {
        switch DataManager.shared.settings.language {
        case .english: return "Show Progress"
        case .russian: return "Показывать прогресс"
        }
    }
    
    var pinCounter: String {
        switch DataManager.shared.settings.language {
        case .english: return "Pin Counter"
        case .russian: return "Закрепить счётчик"
        }
    }
    
    var cancel: String {
        switch DataManager.shared.settings.language {
        case .english: return "Cancel"
        case .russian: return "Отмена"
        }
    }
    
    var createCounter: String {
        switch DataManager.shared.settings.language {
        case .english: return "Create Counter"
        case .russian: return "Создать счётчик"
        }
    }
    
    var save: String {
        switch DataManager.shared.settings.language {
        case .english: return "Save"
        case .russian: return "Сохранить"
        }
    }
    
    // MARK: - Settings
    var dayCounterUser: String {
        switch DataManager.shared.settings.language {
        case .english: return "DayCounter User"
        case .russian: return "Пользователь DayCounter"
        }
    }
    
    var appearance: String {
        switch DataManager.shared.settings.language {
        case .english: return "APPEARANCE"
        case .russian: return "ВНЕШНИЙ ВИД"
        }
    }
    
    var theme: String {
        switch DataManager.shared.settings.language {
        case .english: return "Theme"
        case .russian: return "Тема"
        }
    }
    
    var textSize: String {
        switch DataManager.shared.settings.language {
        case .english: return "Text Size"
        case .russian: return "Размер текста"
        }
    }
    
    var display: String {
        switch DataManager.shared.settings.language {
        case .english: return "DISPLAY"
        case .russian: return "ОТОБРАЖЕНИЕ"
        }
    }
    
    var language: String {
        switch DataManager.shared.settings.language {
        case .english: return "Language"
        case .russian: return "Язык"
        }
    }
    
    // MARK: - Achievements
    var yourProgress: String {
        switch DataManager.shared.settings.language {
        case .english: return "Your progress and milestones"
        case .russian: return "Ваш прогресс и достижения"
        }
    }
    
    var unlocked: String {
        switch DataManager.shared.settings.language {
        case .english: return "Unlocked"
        case .russian: return "Разблокировано"
        }
    }
    
    var total: String {
        switch DataManager.shared.settings.language {
        case .english: return "Total"
        case .russian: return "Всего"
        }
    }
    
    var points: String {
        switch DataManager.shared.settings.language {
        case .english: return "Points"
        case .russian: return "Очки"
        }
    }
    
    // MARK: - Common
    var done: String {
        switch DataManager.shared.settings.language {
        case .english: return "Done"
        case .russian: return "Готово"
        }
    }
    
    var delete: String {
        switch DataManager.shared.settings.language {
        case .english: return "Delete"
        case .russian: return "Удалить"
        }
    }
    
    var edit: String {
        switch DataManager.shared.settings.language {
        case .english: return "Edit"
        case .russian: return "Редактировать"
        }
    }
    
    var viewDetails: String {
        switch DataManager.shared.settings.language {
        case .english: return "View Details"
        case .russian: return "Подробности"
        }
    }
    
    var pin: String {
        switch DataManager.shared.settings.language {
        case .english: return "Pin"
        case .russian: return "Закрепить"
        }
    }
    
    var unpin: String {
        switch DataManager.shared.settings.language {
        case .english: return "Unpin"
        case .russian: return "Открепить"
        }
    }
}
