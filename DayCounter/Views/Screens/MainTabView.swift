//
//  MainTabView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Tab content
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                        .environmentObject(dataManager)
                        .environment(\.sizeCategory, dataManager.settings.textSize == .small ? .small :
                                                    dataManager.settings.textSize == .large ? .large : .medium)
                case 1:
                    AchievementsView()
                        .environmentObject(dataManager)
                        .environment(\.sizeCategory, dataManager.settings.textSize == .small ? .small :
                                                    dataManager.settings.textSize == .large ? .large : .medium)
                case 2:
                    SettingsView()
                        .environmentObject(dataManager)
                default:
                    HomeView()
                        .environmentObject(dataManager)
                        .environment(\.sizeCategory, dataManager.settings.textSize == .small ? .small :
                                                    dataManager.settings.textSize == .large ? .large : .medium)
                }
            }
            
            // Custom bottom bar
            VStack {
                Spacer()
                BottomBarView(
                    onAdd: { selectedTab = 0 },
                    onAchievements: { selectedTab = 1 },
                    onSettings: { selectedTab = 2 },
                    selectedTab: $selectedTab
                )
            }
        }
        .onAppear {
            // Проверяем достижения после полной загрузки приложения
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                AchievementManager.shared.checkAchievements()
            }
        }
    }
}

