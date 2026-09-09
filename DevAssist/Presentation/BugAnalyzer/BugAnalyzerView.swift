//
//  BugAnalyzerView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct BugAnalyzerView: View {
    @StateObject private var viewModel: BugAnalyzerViewModel

    public init(repository: AnalysisRepositoryProtocol) {
        let service = GeminiAIService()
        let useCase = AnalyzeBugUseCase(aiService: service, repository: repository)
        self._viewModel = StateObject(wrappedValue: BugAnalyzerViewModel(useCase: useCase))
    }

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Title & Banner
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            StatusBadge(text: "Diagnose & Remediation", color: Theme.bugRed, systemImage: "ant.fill")
                            Text("Analyze Bug & Crash Logs")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                        Button(action: viewModel.loadSampleSnippet) {
                            Text("Sample Bug")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.bugRed.opacity(0.2))
                                .foregroundColor(Theme.bugRed)
                                .clipShape(Capsule())
                        }
                    }

                    // Input Code Box
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Stack Trace or Failing Code")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        CodeEditorView(codeText: $viewModel.inputCode, placeholder: "// Paste crash logs, stack traces, or failing Swift code...")
                    }

                    // Optional Extra Context / Logs
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Console Logs / Runtime Context (Optional)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        TextField("e.g. EXC_BAD_INSTRUCTION on line 42", text: $viewModel.logsContext)
                            .padding(12)
                            .background(Color(hex: "0F172A"))
                            .foregroundColor(Theme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.borderGlass, lineWidth: 1))
                    }

                    if let errorMsg = viewModel.errorMessage {
                        Text(errorMsg)
                            .font(.caption)
                            .foregroundColor(Theme.bugRed)
                            .padding(.vertical, 4)
                    }

                    PrimaryButton(
                        title: "Analyze Crash & Generate Patch",
                        systemImage: "wand.and.stars",
                        isLoading: viewModel.isLoading,
                        gradient: LinearGradient(colors: [Theme.bugRed, Color.orange], startPoint: .leading, endPoint: .trailing)
                    ) {
                        Task {
                            await viewModel.analyzeBug()
                        }
                    }

                    // Results Output Section
                    if let result = viewModel.result {
                        VStack(alignment: .leading, spacing: 14) {
                            Divider().background(Theme.borderGlass).padding(.vertical, 10)

                            Text("Analysis Results")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)

                            GlassCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        StatusBadge(text: result.severityRating.rawValue, color: result.severityRating == .critical ? .red : .orange)
                                        Text(result.title)
                                            .font(.headline)
                                            .foregroundColor(Theme.textPrimary)
                                    }

                                    Text(result.summary)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)

                                    if let patch = result.codePatch {
                                        Text("Generated Patch Fix:")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(Theme.accentCyan)
                                        CodeEditorView(codeText: .constant(patch), isEditable: false, minHeight: 120)
                                    }

                                    ScrollView {
                                        Text(result.detailedMarkdown)
                                            .font(.caption)
                                            .foregroundColor(Theme.textPrimary)
                                            .padding(.top, 6)
                                    }
                                    .frame(maxHeight: 250)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Bug Analyzer")
        .inlineNavigationBarTitleMode()
    }
}
