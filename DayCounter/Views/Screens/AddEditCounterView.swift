//
//  AddEditCounterView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct AddEditCounterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    let counter: Counter?
    
    @State private var name: String = ""
    @State private var type: CounterType = .countUntil
    @State private var targetDate: Date = Date()
    @State private var startDate: Date = Date()
    @State private var selectedCategoryId: UUID? = nil
    @State private var emoji: String = "📅"
    @State private var selectedColor: String = ColorPalette.defaultColor
    @State private var note: String = ""
    @State private var showProgress: Bool = true
    @State private var isPinned: Bool = false
    @State private var showingEmojiPicker = false
    @State private var showingCategorySheet = false
    
    var isEditMode: Bool {
        counter != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Event Name
                Section(header: Text("Event Name *")) {
                    TextField("e.g. Summer Vacation", text: $name)
                }
                
                // Counter Type
                Section(header: Text("Counter Type *")) {
                    Picker("Type", selection: $type) {
                        Text("Count Until").tag(CounterType.countUntil)
                        Text("Count Since").tag(CounterType.countSince)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Event Date
                Section(header: Text("Event Date *")) {
                    DatePicker("Date", selection: $targetDate, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                }
                
                // Start Date (for progress calculation)
                if type == .countUntil {
                    Section(header: Text("Start Date (for progress)"),
                           footer: Text("Used to calculate percentage progress")) {
                        DatePicker("From", selection: $startDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
                
                // Category
                Section(header: Text("Category")) {
                    Button(action: { showingCategorySheet = true }) {
                        HStack {
                            Text("Category")
                            Spacer()
                            if let categoryId = selectedCategoryId,
                               let category = dataManager.getCategory(id: categoryId) {
                                Text("\(category.emoji) \(category.name)")
                                    .foregroundColor(.secondary)
                            } else {
                                Text("None")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Emoji
                Section(header: Text("Emoji")) {
                    Button(action: { showingEmojiPicker = true }) {
                        HStack {
                            Text("Select Emoji")
                            Spacer()
                            Text(emoji)
                                .font(.system(size: 32))
                        }
                    }
                }
                
                // Accent Color
                Section(header: Text("Accent Color")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ColorPalette.colors, id: \.hex) { colorItem in
                                Button(action: {
                                    selectedColor = colorItem.hex
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: colorItem.hex) ?? .blue)
                                            .frame(width: 44, height: 44)
                                        
                                        if selectedColor == colorItem.hex {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18, weight: .bold))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Note
                Section(header: Text("Note (Optional)")) {
                    TextEditor(text: $note)
                        .frame(height: 80)
                }
                
                // Options
                Section(header: Text("Options")) {
                    Toggle("Show Progress", isOn: $showProgress)
                    Toggle("Pin Counter", isOn: $isPinned)
                }
            }
            .navigationTitle(isEditMode ? "Edit Counter" : "New Counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditMode ? "Save" : "Create Counter") {
                        saveCounter()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPickerView(selectedEmoji: $emoji)
        }
        .sheet(isPresented: $showingCategorySheet) {
            CategoryPickerView(selectedCategoryId: $selectedCategoryId)
                .environmentObject(dataManager)
        }
        .onAppear {
            if let counter = counter {
                name = counter.name
                type = counter.type
                targetDate = counter.targetDate
                startDate = counter.startDate
                selectedCategoryId = counter.categoryId
                emoji = counter.emoji
                selectedColor = counter.color
                note = counter.note ?? ""
                showProgress = counter.showProgress
                isPinned = counter.isPinned
            }
        }
    }
    
    private func saveCounter() {
        if let counter = counter {
            // Edit existing
            var updatedCounter = counter
            updatedCounter.name = name
            updatedCounter.type = type
            updatedCounter.targetDate = targetDate
            updatedCounter.startDate = startDate
            updatedCounter.categoryId = selectedCategoryId
            updatedCounter.emoji = emoji
            updatedCounter.color = selectedColor
            updatedCounter.note = note.isEmpty ? nil : note
            updatedCounter.showProgress = showProgress
            updatedCounter.isPinned = isPinned
            
            dataManager.updateCounter(updatedCounter)
        } else {
            // Create new
            let newCounter = Counter(
                name: name,
                type: type,
                targetDate: targetDate,
                startDate: startDate,
                categoryId: selectedCategoryId,
                emoji: emoji,
                color: selectedColor,
                note: note.isEmpty ? nil : note,
                showProgress: showProgress,
                isPinned: isPinned
            )
            
            dataManager.addCounter(newCounter)
        }
        
        dismiss()
    }
}

// MARK: - Emoji Picker View
struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedEmoji: String
    
    let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(EmojiPicker.emojis, id: \.self) { emoji in
                        Button(action: {
                            selectedEmoji = emoji
                            dismiss()
                        }) {
                            Text(emoji)
                                .font(.system(size: 40))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Category Picker View
struct CategoryPickerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedCategoryId: UUID?
    @State private var showingAddCategory = false
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    selectedCategoryId = nil
                    dismiss()
                }) {
                    HStack {
                        Text("None")
                        Spacer()
                        if selectedCategoryId == nil {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                ForEach(dataManager.categories) { category in
                    Button(action: {
                        selectedCategoryId = category.id
                        dismiss()
                    }) {
                        HStack {
                            Text(category.emoji)
                            Text(category.name)
                            Spacer()
                            if selectedCategoryId == category.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Button(action: { showingAddCategory = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create New Category")
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
                .environmentObject(dataManager)
        }
    }
}

// MARK: - Add Category View
struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name: String = ""
    @State private var emoji: String = "📁"
    @State private var selectedColor: String = ColorPalette.defaultColor
    @State private var showingEmojiPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Name")) {
                    TextField("e.g. Personal", text: $name)
                }
                
                Section(header: Text("Emoji")) {
                    Button(action: { showingEmojiPicker = true }) {
                        HStack {
                            Text("Select Emoji")
                            Spacer()
                            Text(emoji)
                                .font(.system(size: 32))
                        }
                    }
                }
                
                Section(header: Text("Color")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ColorPalette.colors, id: \.hex) { colorItem in
                                Button(action: {
                                    selectedColor = colorItem.hex
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: colorItem.hex) ?? .blue)
                                            .frame(width: 44, height: 44)
                                        
                                        if selectedColor == colorItem.hex {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18, weight: .bold))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        let category = Category(name: name, emoji: emoji, color: selectedColor)
                        dataManager.addCategory(category)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPickerView(selectedEmoji: $emoji)
        }
    }
}

