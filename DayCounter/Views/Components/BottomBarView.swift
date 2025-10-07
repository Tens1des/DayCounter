//
//  BottomBarView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct BottomBarView: View {
    let onAdd: () -> Void
    let onAchievements: () -> Void
    let onSettings: () -> Void
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            // Background bar
            VStack(spacing: 0) {
                Divider()
                    .background(Color.black.opacity(0.05))
                
                HStack {
                    Button(action: { selectedTab = 1 }) {
                        VStack(spacing: 6) {
                            Image(systemName: "rosette")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(selectedTab == 1 ? .blue : .gray)
                            Text(LocalizedStrings.shared.achievements)
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 1 ? .blue : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer(minLength: 56) // space for floating add button width
                    
                    Button(action: { selectedTab = 2 }) {
                        VStack(spacing: 6) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(selectedTab == 2 ? .blue : .gray)
                            Text(LocalizedStrings.shared.settings)
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 2 ? .blue : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemBackground))
                .ignoresSafeArea(edges: .bottom)
            }
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: -2)
            
            // Floating add button
            Button(action: onAdd) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.09, green: 0.11, blue: 0.16)) // тёмный как на макете
                        .frame(width: 58, height: 58)
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 4)
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -22)
            .accessibilityLabel("Add Counter")
        }
    }
}


