//
//  SettingsViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public var apiKeyInput: String = ""
    @Published public var selectedModel: String = "Gemini 2.5 Flash"
    @Published public var isMockEngineEnabled: Bool = false
    @Published public private(set) var saveStatusMessage: String?
    @Published public private(set) var hasSavedKey: Bool = false

    public let availableModels = ["Gemini 2.5 Flash", "Gemini 1.5 Pro", "Local Offline Engine"]

    public init() {
        loadSettings()
    }

    public func loadSettings() {
        if let key = KeychainManager.shared.getAPIKey(), !key.isEmpty {
            self.apiKeyInput = key
            self.hasSavedKey = true
            self.isMockEngineEnabled = false
        } else {
            self.apiKeyInput = ""
            self.hasSavedKey = false
            self.isMockEngineEnabled = true
        }
    }

    public func saveAPIKey() {
        let trimmed = apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            clearAPIKey()
        } else {
            let success = KeychainManager.shared.save(apiKey: trimmed)
            if success {
                hasSavedKey = true
                isMockEngineEnabled = false
                saveStatusMessage = "✅ API Key saved securely in iOS Keychain."
            } else {
                saveStatusMessage = "❌ Failed to save API Key to Keychain."
            }
        }
    }

    public func clearAPIKey() {
        _ = KeychainManager.shared.deleteAPIKey()
        self.apiKeyInput = ""
        self.hasSavedKey = false
        self.isMockEngineEnabled = true
        self.saveStatusMessage = "ℹ️ API Key cleared. Switched to offline engine."
    }
}
