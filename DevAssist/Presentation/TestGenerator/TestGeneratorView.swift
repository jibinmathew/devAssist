//
//  TestGeneratorView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct TestGeneratorView: View {
    @StateObject private var viewModel: TestGeneratorViewModel

    public init(repository: AnalysisRepositoryProtocol) {
        let service = GeminiAIService()
        let useCase = GenerateTestsUseCase(aiService: service, repository: repository)
        self._viewModel = StateObject(wrappedValue: TestGeneratorViewModel(useCase: useCase))
    }

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            StatusBadge(text: "Unit & Async Testing", color: Theme.testPurple, systemImage: "vial.viewfinder")
                            Text("Test Suite Generator")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                        Button(action: viewModel.loadSampleCode) {
                            Text("Sample Code")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.testPurple.opacity(0.2))
                                .foregroundColor(Theme.testPurple)
                                .clipShape(Capsule())
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Target Swift Source Code")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        CodeEditorView(codeText: $viewModel.sourceCodeInput, placeholder: "// Paste Swift ViewModel, Manager, or Service implementation...")
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Target Test Framework")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        Picker("Framework", selection: $viewModel.selectedFramework) {
                            ForEach(viewModel.frameworks, id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    if let errorMsg = viewModel.errorMessage {
                        Text(errorMsg)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    PrimaryButton(
                        title: "Generate Test Suite",
                        systemImage: "play.circle.fill",
                        isLoading: viewModel.isLoading,
                        gradient: LinearGradient(colors: [Theme.testPurple, Theme.accentIndigo], startPoint: .leading, endPoint: .trailing)
                    ) {
                        Task {
                            await viewModel.generateTests()
                        }
                    }

                    if let result = viewModel.result {
                        VStack(alignment: .leading, spacing: 14) {
                            Divider().background(Theme.borderGlass).padding(.vertical, 10)

                            Text("Generated Unit Tests")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)

                            GlassCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(result.title)
                                        .font(.headline)
                                        .foregroundColor(Theme.textPrimary)

                                    Text(result.summary)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)

                                    if let patch = result.codePatch {
                                        Text("Executable Unit Test File:")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(Theme.accentCyan)
                                        CodeEditorView(codeText: .constant(patch), isEditable: false, minHeight: 160)
                                    }

                                    ScrollView {
                                        Text(result.detailedMarkdown)
                                            .font(.caption)
                                            .foregroundColor(Theme.textPrimary)
                                            .padding(.top, 6)
                                    }
                                    .frame(maxHeight: 200)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Test Suite Generator")
        .inlineNavigationBarTitleMode()
    }
}
