//
//  CounterCardView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct CounterCardView: View {
    let counter: Counter
    let category: Category?
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Left colored bar
            Rectangle()
                .fill(counter.colorValue)
                .frame(width: 4)
                .cornerRadius(2)
            
            // Emoji circle
            ZStack {
                Circle()
                    .fill(counter.colorValue.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Text(counter.emoji)
                    .font(.system(size: 28))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                // Name and category
                HStack(spacing: 8) {
                    if counter.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    
                    Text(counter.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if let category = category {
                        HStack(spacing: 4) {
                            Text(category.emoji)
                                .font(.system(size: 10))
                            Text(category.name)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(category.colorValue)
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                
                // Time count with format
                let timeFormat = counter.timeFormat ?? dataManager.settings.defaultTimeFormat
                Text(counter.formattedTime(using: timeFormat))
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.primary)
                
                // Time unit label and date
                HStack {
                    Text(counter.timeUnitLabel(for: timeFormat))
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(counter.targetDate.formatted(format: "MMM d, yyyy"))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                // Progress bar for Count Until
                if counter.type == .countUntil && counter.showProgress {
                    HStack(spacing: 8) {
                        Text("Progress")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(counter.progressPercentage))%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(counter.colorValue)
                                .frame(width: geometry.size.width * CGFloat(min(counter.progressPercentage / 100, 1.0)), height: 6)
                                .cornerRadius(3)
                        }
                    }
                    .frame(height: 6)
                }
                
                // Note if exists
                if let note = counter.note, !note.isEmpty {
                    Text(note)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .padding(.top, 2)
                }
                
                // Time breakdown for Count Since
                if counter.type == .countSince, let anniversary = counter.anniversary {
                    HStack(spacing: 16) {
                        if anniversary.years > 0 {
                            VStack {
                                Text("\(anniversary.years)")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("years")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if anniversary.months > 0 {
                            VStack {
                                Text("\(anniversary.months)")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("months")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        VStack {
                            Text("\(anniversary.days)")
                                .font(.system(size: 16, weight: .semibold))
                            Text("days")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 8)
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

