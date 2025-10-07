//
//  DayCounterApp.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

@main
struct DayCounterApp: App {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dataManager)
                .preferredColorScheme(dataManager.settings.theme == .light ? .light : 
                                    dataManager.settings.theme == .dark ? .dark : nil)
        }
    }
}
