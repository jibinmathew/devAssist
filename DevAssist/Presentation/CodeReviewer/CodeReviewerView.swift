//
//  CodeReviewerView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct CodeReviewerView: View {
    @StateObject private var viewModel: CodeReviewerViewModel

    public init(repository: AnalysisRepositoryProtocol) {
        let service = GeminiAIService()
        let useCase = ReviewCodeUseCase(aiService: service, repository: repository)
        self._viewModel = StateObject(wrappedValue: CodeReviewerViewModel(useCase: useCase))
    }

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            StatusBadge(text: "Memory & Performance Audit", color: Theme.reviewEmerald, systemImage: "text.magnifyingglass")
                            Text("Code Reviewer")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                        Button(action: viewModel.loadSampleDiff) {
                            Text("Sample PR/Diff")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.reviewEmerald.opacity(0.2))
                                .foregroundColor(Theme.reviewEmerald)
                                .clipShape(Capsule())
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Source Code / Git Diff for Review")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        CodeEditorView(codeText: $viewModel.codeOrDiffInput, placeholder: "// Paste Swift code or Git diff for static analysis...")
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Audit Focus Areas (Optional)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        TextField("e.g. Memory leaks, retain cycles, actor isolation", text: $viewModel.focusAreaInput)
                            .padding(12)
                            .background(Color(hex: "0F172A"))
                            .foregroundColor(Theme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.borderGlass, lineWidth: 1))
                    }

                    if let errorMsg = viewModel.errorMessage {
                        Text(errorMsg)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    PrimaryButton(
                        title: "Perform Code Review Audit",
                        systemImage: "checkmark.seal.fill",
                        isLoading: viewModel.isLoading,
                        gradient: LinearGradient(colors: [Theme.reviewEmerald, Theme.accentCyan], startPoint: .leading, endPoint: .trailing)
                    ) {
                        Task {
                            await viewModel.reviewCode()
                        }
                    }

                    if let result = viewModel.result {
                        VStack(alignment: .leading, spacing: 14) {
                            Divider().background(Theme.borderGlass).padding(.vertical, 10)

                            Text("Review Audit Findings")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)

                            GlassCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        StatusBadge(text: result.severityRating.rawValue, color: Theme.reviewEmerald)
                                        Text(result.title)
                                            .font(.headline)
                                            .foregroundColor(Theme.textPrimary)
                                    }

                                    Text(result.summary)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)

                                    if let patch = result.codePatch {
                                        Text("Refactored Safe Implementation:")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(Theme.accentCyan)
                                        CodeEditorView(codeText: .constant(patch), isEditable: false, minHeight: 140)
                                    }

                                    ScrollView {
                                        Text(result.detailedMarkdown)
                                            .font(.caption)
                                            .foregroundColor(Theme.textPrimary)
                                            .padding(.top, 6)
                                    }
                                    .frame(maxHeight: 220)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Code Reviewer")
        .inlineNavigationBarTitleMode()
    }
}
