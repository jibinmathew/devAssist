//
//  ArchDesignerView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct ArchDesignerView: View {
    @StateObject private var viewModel: ArchDesignerViewModel

    public init(repository: AnalysisRepositoryProtocol) {
        let service = GeminiAIService()
        let useCase = DesignArchitectureUseCase(aiService: service, repository: repository)
        self._viewModel = StateObject(wrappedValue: ArchDesignerViewModel(useCase: useCase))
    }

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            StatusBadge(text: "Clean Architecture Blueprint", color: Theme.archBlue, systemImage: "square.3.layers.3d.down.right")
                            Text("Architecture Designer")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                        Button(action: viewModel.loadSampleRequirements) {
                            Text("Sample Specs")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.archBlue.opacity(0.2))
                                .foregroundColor(Theme.archBlue)
                                .clipShape(Capsule())
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("App Feature & System Requirements")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        CodeEditorView(codeText: $viewModel.requirementsInput, placeholder: "Describe feature scope, data models, or system goals...")
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Architecture Constraints (Optional)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        TextField("e.g. SwiftData offline cache, MVVM-C, Actors", text: $viewModel.constraintsInput)
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
                        title: "Generate Architecture Specs",
                        systemImage: "cpu",
                        isLoading: viewModel.isLoading,
                        gradient: LinearGradient(colors: [Theme.archBlue, Theme.accentIndigo], startPoint: .leading, endPoint: .trailing)
                    ) {
                        Task {
                            await viewModel.generateArchitecture()
                        }
                    }

                    if let result = viewModel.result {
                        VStack(alignment: .leading, spacing: 14) {
                            Divider().background(Theme.borderGlass).padding(.vertical, 10)

                            Text("Architecture Specification")
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
                                        Text("Protocol & Layer Implementations:")
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
                                    .frame(maxHeight: 250)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Architecture Designer")
        .inlineNavigationBarTitleMode()
    }
}
