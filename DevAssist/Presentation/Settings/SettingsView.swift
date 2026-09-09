//
//  SettingsView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    public init() {}

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // API Key Configuration Card
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Image(systemName: "key.fill")
                                    .foregroundColor(Theme.accentCyan)
                                Text("AI API Credentials")
                                    .font(.headline)
                                    .foregroundColor(Theme.textPrimary)

                                Spacer()

                                if viewModel.hasSavedKey {
                                    StatusBadge(text: "Keychain Configured", color: Theme.reviewEmerald, systemImage: "checkmark.seal.fill")
                                } else {
                                    StatusBadge(text: "Offline Mode", color: Theme.accentIndigo, systemImage: "wifi.slash")
                                }
                            }

                            Text("Enter your Gemini AI API key to enable live API inference. If left empty, DevPilot seamlessly operates using the local offline analysis engine.")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("API Key")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.textSecondary)

                                SecureField("Enter Gemini API Key (e.g. AIzaSy...)", text: $viewModel.apiKeyInput)
                                    .padding(12)
                                    .background(Color(hex: "0F172A"))
                                    .foregroundColor(Theme.textPrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.borderGlass, lineWidth: 1))
                            }

                            HStack(spacing: 12) {
                                PrimaryButton(
                                    title: "Save Key",
                                    systemImage: "checkmark.lock.fill",
                                    gradient: LinearGradient(colors: [Theme.accentIndigo, Theme.accentCyan], startPoint: .leading, endPoint: .trailing)
                                ) {
                                    viewModel.saveAPIKey()
                                }

                                if viewModel.hasSavedKey || !viewModel.apiKeyInput.isEmpty {
                                    Button(action: viewModel.clearAPIKey) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "trash.fill")
                                            Text("Clear")
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.bugRed)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                        .background(Theme.bugRed.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.bugRed.opacity(0.3), lineWidth: 1))
                                    }
                                }
                            }

                            if let msg = viewModel.saveStatusMessage {
                                Text(msg)
                                    .font(.caption)
                                    .foregroundColor(Theme.accentCyan)
                                    .padding(.top, 4)
                            }
                        }
                    }

                    // Engine & Model Selection Card
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(Theme.accentIndigo)
                                Text("Engine & Model Selection")
                                    .font(.headline)
                                    .foregroundColor(Theme.textPrimary)
                            }

                            Toggle("Force Offline Engine", isOn: $viewModel.isMockEngineEnabled)
                                .tint(Theme.accentIndigo)
                                .foregroundColor(Theme.textPrimary)

                            Divider().background(Theme.borderGlass)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Target Model")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)

                                Picker("Model", selection: $viewModel.selectedModel) {
                                    ForEach(viewModel.availableModels, id: \.self) { model in
                                        Text(model).tag(model)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                    }

                    // App Info Card
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Theme.accentCyan)
                                Text("About DevPilot")
                                    .font(.headline)
                                    .foregroundColor(Theme.textPrimary)
                            }

                            Text("DevPilot iOS is built using Swift 6, SwiftUI, SwiftData, Swift Concurrency, Clean Architecture, and protocol-oriented domain layers.")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)

                            Text("Version 1.0.0 (Build 2026.09)")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(Theme.textSecondary.opacity(0.7))
                                .padding(.top, 4)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Settings")
        .inlineNavigationBarTitleMode()
    }
}
