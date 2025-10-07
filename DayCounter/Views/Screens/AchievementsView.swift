//
//  AchievementsView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var unlockedCount: Int {
        dataManager.achievements.filter { $0.isUnlocked }.count
    }
    
    var totalPoints: Int {
        dataManager.achievements.filter { $0.isUnlocked }.reduce(0) { $0 + $1.points }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats Header
                    HStack(spacing: 20) {
                        statCard(
                            value: "\(unlockedCount)",
                            label: "Unlocked",
                            color: .blue
                        )
                        
                        statCard(
                            value: "\(dataManager.achievements.count)",
                            label: "Total",
                            color: .purple
                        )
                        
                        statCard(
                            value: "\(totalPoints)",
                            label: "Points",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Achievements Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(dataManager.achievements) { achievement in
                            AchievementCardView(achievement: achievement)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func statCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(color.opacity(0.1))
        .cornerRadius(16)
    }
}

// MARK: - Achievement Card View
struct AchievementCardView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(achievement.isUnlocked ? achievement.rarity.color : Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                
                Text(achievement.icon)
                    .font(.system(size: 40))
                    .opacity(achievement.isUnlocked ? 1.0 : 0.3)
                
                if !achievement.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .offset(x: 25, y: -25)
                }
            }
            
            // Name
            Text(achievement.name)
                .font(.system(size: 16, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                .lineLimit(2)
            
            // Rarity
            Text(achievement.rarity.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(achievement.isUnlocked ? achievement.rarity.color : .secondary)
            
            // Status
            if achievement.isUnlocked {
                if let date = achievement.unlockedDate {
                    Text("Unlocked \(date.formatted(format: "MMM d, yyyy"))")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            } else {
                if let progressText = achievement.progressText {
                    // Progress bar
                    VStack(spacing: 4) {
                        Text("Progress")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        
                        Text(progressText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        if let progress = achievement.progress,
                           let maxProgress = achievement.maxProgress {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 4)
                                        .cornerRadius(2)
                                    
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: geometry.size.width * CGFloat(progress) / CGFloat(maxProgress), height: 4)
                                        .cornerRadius(2)
                                }
                            }
                            .frame(height: 4)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

