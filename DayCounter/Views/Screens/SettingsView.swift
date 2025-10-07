//
//  SettingsView.swift
//  DayCounter
//
//  Created by Рома Котов on 07.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var showingProfileEdit = false
    @State private var settings: UserSettings
    
    init() {
        _settings = State(initialValue: DataManager.shared.settings)
    }
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    Button(action: { showingProfileEdit = true }) {
                        HStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                
                                Text(settings.profile.avatarEmoji)
                                    .font(.system(size: 32))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(settings.profile.name)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(LocalizedStrings.shared.dayCounterUser)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Appearance Section
                Section(header: Text("APPEARANCE")) {
                    // Theme
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Theme")
                                .font(.system(size: 16))
                            Text(settings.theme.displayName)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $settings.theme) {
                            ForEach(AppTheme.allCases, id: \.self) { theme in
                                Text(theme.displayName).tag(theme)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    
                    // Text Size
                    HStack {
                        Image(systemName: "textformat.size")
                            .foregroundColor(.green)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Text Size")
                                .font(.system(size: 16))
                            Text(settings.textSize.displayName)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $settings.textSize) {
                            ForEach(TextSize.allCases, id: \.self) { size in
                                Text(size.displayName).tag(size)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // Display Section
                Section(header: Text("DISPLAY")) {
                    // Language
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Language")
                                .font(.system(size: 16))
                            Text(settings.language.displayName)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $settings.language) {
                            ForEach(AppLanguage.allCases, id: \.self) { language in
                                Text(language.displayName).tag(language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
            }
            .navigationTitle(LocalizedStrings.shared.settings)
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingProfileEdit) {
            ProfileEditView(profile: settings.profile) { newProfile in
                settings.profile = newProfile
            }
        }
        .onChange(of: settings) { newSettings in
            dataManager.updateSettings(newSettings)
        }
        .onChange(of: settings.language) { _ in
            // Force UI refresh when language changes
            DispatchQueue.main.async {
                // This will trigger a UI refresh
            }
        }
        .preferredColorScheme(settings.theme == .light ? .light : 
                            settings.theme == .dark ? .dark : nil)
        .environment(\.sizeCategory, settings.textSize == .small ? .small :
                                    settings.textSize == .large ? .large : .medium)
    }
}

// MARK: - Profile Edit View
struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    
    let profile: UserProfile
    let onSave: (UserProfile) -> Void
    
    @State private var name: String
    @State private var avatarEmoji: String
    @State private var showingAvatarPicker = false
    
    init(profile: UserProfile, onSave: @escaping (UserProfile) -> Void) {
        self.profile = profile
        self.onSave = onSave
        _name = State(initialValue: profile.name)
        _avatarEmoji = State(initialValue: profile.avatarEmoji)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("PROFILE")) {
                    // Avatar
                    Button(action: { showingAvatarPicker = true }) {
                        HStack {
                            Text("Avatar")
                            Spacer()
                            Text(avatarEmoji)
                                .font(.system(size: 40))
                        }
                    }
                    
                    // Name
                    TextField("Name", text: $name)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newProfile = UserProfile(name: name, avatarEmoji: avatarEmoji)
                        onSave(newProfile)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingAvatarPicker) {
            AvatarPickerView(selectedAvatar: $avatarEmoji)
        }
    }
}

// MARK: - Avatar Picker View
struct AvatarPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAvatar: String
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(AvatarPicker.avatars, id: \.self) { avatar in
                        Button(action: {
                            selectedAvatar = avatar
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                
                                Text(avatar)
                                    .font(.system(size: 40))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Avatar")
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

