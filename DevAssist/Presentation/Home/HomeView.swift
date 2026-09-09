//
//  HomeView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let repository: AnalysisRepositoryProtocol

    public init(repository: AnalysisRepositoryProtocol) {
        self.repository = repository
        self._viewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgGradient.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header Banner
                        headerBanner

                        // Core Developer AI Tool Cards
                        Text("Developer Tools")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            NavigationLink(destination: BugAnalyzerView(repository: repository)) {
                                toolCard(type: .bugAnalysis, count: viewModel.bugCount, color: Theme.bugRed)
                            }

                            NavigationLink(destination: ArchDesignerView(repository: repository)) {
                                toolCard(type: .architectureDesign, count: viewModel.archCount, color: Theme.archBlue)
                            }

                            NavigationLink(destination: TestGeneratorView(repository: repository)) {
                                toolCard(type: .testGeneration, count: viewModel.testCount, color: Theme.testPurple)
                            }

                            NavigationLink(destination: CodeReviewerView(repository: repository)) {
                                toolCard(type: .codeReview, count: viewModel.reviewCount, color: Theme.reviewEmerald)
                            }
                        }

                        // Recent Activity Feed
                        HStack {
                            Text("Recent Analyses")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)

                            Spacer()

                            NavigationLink(destination: HistoryListView(repository: repository)) {
                                Text("View All")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.accentCyan)
                            }
                        }

                        if viewModel.recentRecords.isEmpty {
                            GlassCard {
                                VStack(spacing: 8) {
                                    Image(systemName: "cpu")
                                        .font(.largeTitle)
                                        .foregroundColor(Theme.textSecondary)
                                    Text("No analyses generated yet")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)
                                    Text("Tap one of the tools above to run AI diagnostic & architecture generation.")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Theme.textSecondary.opacity(0.8))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                            }
                        } else {
                            VStack(spacing: 10) {
                                ForEach(viewModel.recentRecords) { record in
                                    NavigationLink(destination: HistoryDetailView(result: record)) {
                                        historyRow(record)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("DevPilot AI")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Theme.accentCyan)
                    }
                }
#else
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Theme.accentCyan)
                    }
                }
#endif
            }
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
        }
    }

    private var headerBanner: some View {
        GlassCard(cornerRadius: 20) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    StatusBadge(text: "Clean Architecture iOS App", color: Theme.accentCyan, systemImage: "sparkles")
                    Text("Developer AI Workspace")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                    Text("Architected with Swift Concurrency & SwiftData")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Theme.accentIndigo, Theme.accentCyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 54, height: 54)
                    Image(systemName: "laptopcomputer.and.iphone")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
    }

    private func toolCard(type: AnalysisType, count: Int, color: Color) -> some View {
        GlassCard(cornerRadius: 16, padding: 14) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: type.systemImage)
                            .font(.headline)
                            .foregroundColor(color)
                    }
                    Spacer()
                    Text("\(count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(Theme.textPrimary)
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(type.title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                    Text(type.subtitle)
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func historyRow(_ record: AnalysisResult) -> some View {
        GlassCard(cornerRadius: 12, padding: 12) {
            HStack(spacing: 12) {
                Image(systemName: record.type.systemImage)
                    .foregroundColor(Theme.accentCyan)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                    Text(record.summary)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}
