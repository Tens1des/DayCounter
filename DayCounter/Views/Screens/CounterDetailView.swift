//
//  CounterDetailView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct CounterDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    let counterId: UUID
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var counter: Counter? {
        dataManager.counters.first { $0.id == counterId }
    }
    
    var category: Category? {
        guard let counter = counter else { return nil }
        return dataManager.getCategory(id: counter.categoryId)
    }
    
    private func timeBreakdownItem(value: Int, unit: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(unit)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let counter = counter {
                    ZStack {
                        // Background gradient
                        LinearGradient(
                            gradient: Gradient(colors: [
                                counter.colorValue,
                                counter.colorValue.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                // Top section with icon and category
                                VStack(spacing: 12) {
                                    if let category = category {
                                        HStack(spacing: 6) {
                                            Text(category.emoji)
                                                .font(.system(size: 14))
                                            Text(category.name)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(12)
                                    }
                                    
                                    // Emoji icon
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .frame(width: 100, height: 100)
                                        
                                        Text(counter.emoji)
                                            .font(.system(size: 60))
                                    }
                                    .padding(.top, 20)
                                }
                                
                                // Counter card
                                VStack(spacing: 16) {
                                    // Title
                                    Text(counter.name)
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                    
                                    // Date
                                    HStack {
                                        Image(systemName: "calendar")
                                        Text(counter.targetDate.formatted(format: "MMMM d, yyyy"))
                                    }
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                    
                                    // Main counter display
                                    VStack(spacing: 8) {
                                        Text("\(abs(counter.daysCount))")
                                            .font(.system(size: 80, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Text(counter.type == .countUntil ? "days remaining" : "days passed")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .padding(.vertical, 20)
                                    
                                    // Progress bar for Count Until
                                    if counter.type == .countUntil && counter.showProgress {
                                        VStack(spacing: 8) {
                                            HStack {
                                                Text("Progress")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.white.opacity(0.9))
                                                
                                                Spacer()
                                                
                                                Text("\(Int(counter.progressPercentage))%")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            GeometryReader { geometry in
                                                ZStack(alignment: .leading) {
                                                    Rectangle()
                                                        .fill(Color.white.opacity(0.3))
                                                        .frame(height: 10)
                                                        .cornerRadius(5)
                                                    
                                                    Rectangle()
                                                        .fill(Color.white)
                                                        .frame(width: geometry.size.width * CGFloat(min(counter.progressPercentage / 100, 1.0)), height: 10)
                                                        .cornerRadius(5)
                                                }
                                            }
                                            .frame(height: 10)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Time breakdown
                                if counter.type == .countSince, let anniversary = counter.anniversary {
                                    HStack(spacing: 24) {
                                        if anniversary.years > 0 {
                                            timeBreakdownItem(value: anniversary.years, unit: "years")
                                        }
                                        
                                        if anniversary.months > 0 {
                                            timeBreakdownItem(value: anniversary.months, unit: "months")
                                        }
                                        
                                        timeBreakdownItem(value: anniversary.days, unit: "days")
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                // Note section
                                if let note = counter.note, !note.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "note.text")
                                            Text("Notes")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .foregroundColor(.white.opacity(0.9))
                                        
                                        Text(note)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white.opacity(0.15))
                                            .cornerRadius(12)
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                Spacer(minLength: 40)
                            }
                            .padding(.top, 40)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack(spacing: 16) {
                                Button(action: { showingEditSheet = true }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
                                }
                                
                                Button(action: { showingDeleteAlert = true }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showingEditSheet) {
                        AddEditCounterView(counter: counter)
                            .environmentObject(dataManager)
                    }
                    .alert("Delete Counter", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            dataManager.deleteCounter(counter)
                            dismiss()
                        }
                    } message: {
                        Text("Are you sure you want to delete this counter? This action cannot be undone.")
                    }
                } else {
                    // Counter not found
                    VStack(spacing: 20) {
                        Text("Counter not found")
                            .font(.title2)
                        Text("ID: \(counterId.uuidString)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Total counters: \(dataManager.counters.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Go Back") {
                            dismiss()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}