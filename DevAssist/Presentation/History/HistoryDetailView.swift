//
//  HistoryDetailView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct HistoryDetailView: View {
    public let result: AnalysisResult

    public init(result: AnalysisResult) {
        self.result = result
    }

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Header Card
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                StatusBadge(text: result.type.rawValue, color: Theme.accentIndigo, systemImage: result.type.systemImage)
                                Spacer()
                                Text(result.createdAt, format: .dateTime.month().day().hour().minute())
                                    .font(.caption2)
                                    .foregroundColor(Theme.textSecondary)
                            }

                            Text(result.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)

                            Text(result.summary)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(result.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .font(.caption2)
                                            .foregroundColor(Theme.accentCyan)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Theme.accentCyan.opacity(0.15))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    // Input Snippet Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Original Input Snippet")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        CodeEditorView(codeText: .constant(result.inputSnippet), isEditable: false, minHeight: 100)
                    }

                    // Code Patch Section
                    if let patch = result.codePatch {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Generated Code Patch")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.textSecondary)

                            CodeEditorView(codeText: .constant(patch), isEditable: false, minHeight: 140)
                        }
                    }

                    // Full Detailed Breakdown
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Detailed AI Breakdown")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textSecondary)

                        GlassCard {
                            Text(result.detailedMarkdown)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(Theme.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Analysis Detail")
        .inlineNavigationBarTitleMode()
    }
}
