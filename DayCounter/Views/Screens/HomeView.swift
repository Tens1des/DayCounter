//
//  HomeView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedCategory: UUID? = nil
    @State private var searchText = ""
    @State private var selectedCounterId: UUID? = nil
    @State private var showingCounterDetail = false
    @State private var showingAddCounter = false
    
    var filteredCounters: [Counter] {
        var counters = dataManager.counters
        
        // Filter by category
        if let categoryId = selectedCategory {
            counters = counters.filter { $0.categoryId == categoryId }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            counters = counters.filter { counter in
                counter.name.localizedCaseInsensitiveContains(searchText) ||
                (counter.note?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return counters
    }
    
    var pinnedCounters: [Counter] {
        filteredCounters.filter { $0.isPinned }
    }
    
    var unpinnedCounters: [Counter] {
        filteredCounters.filter { !$0.isPinned }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if dataManager.counters.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Search bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField(LocalizedStrings.shared.search, text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Category filters
                            if !dataManager.categories.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        CategoryFilterButton(
                                            title: LocalizedStrings.shared.all,
                                            emoji: nil,
                                            isSelected: selectedCategory == nil
                                        ) {
                                            selectedCategory = nil
                                        }
                                        
                                        ForEach(dataManager.categories) { category in
                                            CategoryFilterButton(
                                                title: category.name,
                                                emoji: category.emoji,
                                                isSelected: selectedCategory == category.id
                                            ) {
                                                selectedCategory = category.id
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Pinned counters
                            if !pinnedCounters.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(LocalizedStrings.shared.pinned)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                    
                            ForEach(pinnedCounters) { counter in
                                Button(action: {
                                    // Проверяем что счётчик существует перед открытием
                                    if dataManager.counters.contains(where: { $0.id == counter.id }) {
                                        selectedCounterId = counter.id
                                        showingCounterDetail = true
                                    }
                                }) {
                                    CounterCardView(
                                        counter: counter,
                                        category: dataManager.getCategory(id: counter.categoryId)
                                    )
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    counterContextMenu(counter: counter)
                                }
                            }
                                }
                            }
                            
                            // All counters
                            if !unpinnedCounters.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(pinnedCounters.isEmpty ? LocalizedStrings.shared.allCounters : LocalizedStrings.shared.all)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                    
                            ForEach(unpinnedCounters) { counter in
                                Button(action: {
                                    // Проверяем что счётчик существует перед открытием
                                    if dataManager.counters.contains(where: { $0.id == counter.id }) {
                                        selectedCounterId = counter.id
                                        showingCounterDetail = true
                                    }
                                }) {
                                    CounterCardView(
                                        counter: counter,
                                        category: dataManager.getCategory(id: counter.categoryId)
                                    )
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    counterContextMenu(counter: counter)
                                }
                            }
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(LocalizedStrings.shared.dayCounter)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: { showingAddCounter = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddCounter) {
                AddEditCounterView(counter: nil)
                    .environmentObject(dataManager)
            }
            .sheet(isPresented: $showingCounterDetail, onDismiss: {
                // Сбрасываем selectedCounterId при закрытии
                selectedCounterId = nil
            }) {
                if let counterId = selectedCounterId,
                   dataManager.counters.contains(where: { $0.id == counterId }) {
                    CounterDetailView(counterId: counterId)
                        .environmentObject(dataManager)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        
                        Text("Counter not found")
                            .font(.title2)
                        
                        Text("This counter may have been deleted")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Close") {
                            showingCounterDetail = false
                            selectedCounterId = nil
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Empty State
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(LocalizedStrings.shared.noCountersYet)
                .font(.system(size: 24, weight: .bold))
            
            Text(LocalizedStrings.shared.createFirstCounter)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingAddCounter = true }) {
                Text(LocalizedStrings.shared.createFirstCounterButton)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
    }
    
    
    
    // MARK: - Context Menu
    @ViewBuilder
    func counterContextMenu(counter: Counter) -> some View {
        Button(action: {
            // Проверяем что счётчик существует перед открытием
            if dataManager.counters.contains(where: { $0.id == counter.id }) {
                selectedCounterId = counter.id
                showingCounterDetail = true
            }
        }) {
            Label(LocalizedStrings.shared.viewDetails, systemImage: "eye")
        }
        
        Button(action: {
            dataManager.togglePin(counter)
        }) {
            Label(counter.isPinned ? LocalizedStrings.shared.unpin : LocalizedStrings.shared.pin, systemImage: "pin")
        }
        
        Button(role: .destructive, action: {
            dataManager.deleteCounter(counter)
        }) {
            Label(LocalizedStrings.shared.delete, systemImage: "trash")
        }
    }
}

// MARK: - Category Filter Button
struct CategoryFilterButton: View {
    let title: String
    let emoji: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let emoji = emoji {
                    Text(emoji)
                        .font(.system(size: 16))
                }
                Text(title)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

