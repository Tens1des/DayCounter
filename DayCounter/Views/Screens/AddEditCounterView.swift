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
    @State private var selectedTimeFormat: TimeFormat? = nil
    @State private var showingEmojiPicker = false
    @State private var showingCategorySheet = false
    
    var isEditMode: Bool {
        counter != nil
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Preview Card
                    VStack(spacing: 16) {
                        // Emoji Circle
                        ZStack {
                            Circle()
                                .fill(Color(hex: selectedColor)?.opacity(0.15) ?? Color.blue.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            Text(emoji)
                                .font(.system(size: 50))
                        }
                        
                        // Name Preview
                        Text(name.isEmpty ? "Event Name" : name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(name.isEmpty ? .gray : .primary)
                        
                        // Type Badge
                        Text(type == .countUntil ? LocalizedStrings.shared.countUntil : LocalizedStrings.shared.countSince)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color(hex: selectedColor) ?? .blue)
                            .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // Event Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStrings.shared.eventName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            TextField("e.g. Summer Vacation", text: $name)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Counter Type
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStrings.shared.counterType)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Picker("Type", selection: $type) {
                                Text(LocalizedStrings.shared.countUntil).tag(CounterType.countUntil)
                                Text(LocalizedStrings.shared.countSince).tag(CounterType.countSince)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding(.horizontal)
                        
                        // Event Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStrings.shared.eventDate)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            DatePicker("", selection: $targetDate, displayedComponents: [.date])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Start Date (for progress)
                        if type == .countUntil {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Start Date (for progress)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                Text("Used to calculate percentage progress")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                DatePicker("", selection: $startDate, displayedComponents: [.date])
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Customization Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("CUSTOMIZATION")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                // Emoji Picker
                                Button(action: { showingEmojiPicker = true }) {
                                    HStack {
                                        Image(systemName: "face.smiling")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                            .frame(width: 32)
                                        
                                        Text(LocalizedStrings.shared.emoji)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text(emoji)
                                            .font(.system(size: 28))
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                                
                                // Color Picker
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "paintpalette")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                            .frame(width: 32)
                                        
                                        Text(LocalizedStrings.shared.accentColor)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(ColorPalette.colors, id: \.hex) { colorItem in
                                                Button(action: {
                                                    selectedColor = colorItem.hex
                                                }) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(hex: colorItem.hex) ?? .blue)
                                                            .frame(width: 50, height: 50)
                                                        
                                                        if selectedColor == colorItem.hex {
                                                            Circle()
                                                                .stroke(Color.primary, lineWidth: 3)
                                                                .frame(width: 58, height: 58)
                                                            
                                                            Image(systemName: "checkmark")
                                                                .foregroundColor(.white)
                                                                .font(.system(size: 20, weight: .bold))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.vertical, 12)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                                
                                // Category Picker
                                Button(action: { showingCategorySheet = true }) {
                                    HStack {
                                        Image(systemName: "folder")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                            .frame(width: 32)
                                        
                                        Text(LocalizedStrings.shared.category)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        if let categoryId = selectedCategoryId,
                                           let category = dataManager.getCategory(id: categoryId) {
                                            Text("\(category.emoji)")
                                                .font(.system(size: 20))
                                            Text(category.name)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("None")
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Note
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "note.text")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                    .frame(width: 32)
                                
                                Text(LocalizedStrings.shared.note)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            
                            TextEditor(text: $note)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Options
                        VStack(spacing: 12) {
                            // Time Format
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "clock")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                        .frame(width: 32)
                                    
                                    Text("Time Format")
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $selectedTimeFormat) {
                                        Text("Default (\(dataManager.settings.defaultTimeFormat.displayName))").tag(nil as TimeFormat?)
                                        ForEach(TimeFormat.allCases, id: \.self) { format in
                                            Text(format.displayName).tag(format as TimeFormat?)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                    .frame(width: 32)
                                
                                Text(LocalizedStrings.shared.showProgress)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Toggle("", isOn: $showProgress)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            
                            HStack {
                                Image(systemName: "pin.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: selectedColor) ?? .blue)
                                    .frame(width: 32)
                                
                                Text(LocalizedStrings.shared.pinCounter)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isPinned)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Create/Save Button
                        Button(action: { saveCounter() }) {
                            Text(isEditMode ? LocalizedStrings.shared.save : LocalizedStrings.shared.createCounter)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(name.isEmpty ? Color.gray : (Color(hex: selectedColor) ?? .blue))
                                .cornerRadius(16)
                        }
                        .disabled(name.isEmpty)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle(isEditMode ? LocalizedStrings.shared.editCounter : LocalizedStrings.shared.newCounter)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStrings.shared.cancel) {
                        dismiss()
                    }
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
                selectedTimeFormat = counter.timeFormat
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
            updatedCounter.timeFormat = selectedTimeFormat
            
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
                isPinned: isPinned,
                timeFormat: selectedTimeFormat
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

