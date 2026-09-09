//
//  HistoryListView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct HistoryListView: View {
    @StateObject private var viewModel: HistoryViewModel

    public init(repository: AnalysisRepositoryProtocol) {
        self._viewModel = StateObject(wrappedValue: HistoryViewModel(repository: repository))
    }

    public var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            VStack(spacing: 14) {
                // Category Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterButton(title: "All", type: nil)
                        ForEach(AnalysisType.allCases) { type in
                            filterButton(title: type.rawValue, type: type)
                        }
                    }
                    .padding(.horizontal)
                }

                if viewModel.filteredRecords.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "tray")
                            .font(.system(size: 44))
                            .foregroundColor(Theme.textSecondary)
                        Text("No matching history found")
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                        Text("Completed analyses will automatically persist here using SwiftData.")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredRecords) { record in
                            NavigationLink(destination: HistoryDetailView(result: record)) {
                                historyRow(record)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.delete(id: record.id)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.top, 10)
        }
        .navigationTitle("History & Logs")
        .searchable(text: $viewModel.searchText, prompt: "Search past analyses or tags...")
        .toolbar {
            if !viewModel.records.isEmpty {
#if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.clearAll()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Theme.bugRed)
                    }
                }
#else
                ToolbarItem(placement: .automatic) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.clearAll()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Theme.bugRed)
                    }
                }
#endif
            }
        }
        .onAppear {
            Task {
                await viewModel.loadRecords()
            }
        }
    }

    private func filterButton(title: String, type: AnalysisType?) -> some View {
        let isSelected = viewModel.selectedFilter == type
        return Button {
            withAnimation {
                viewModel.selectedFilter = type
            }
        } label: {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.accentIndigo : Color.white.opacity(0.1))
                .foregroundColor(isSelected ? .white : Theme.textSecondary)
                .clipShape(Capsule())
        }
    }

    private func historyRow(_ record: AnalysisResult) -> some View {
        GlassCard(cornerRadius: 14, padding: 12) {
            HStack(spacing: 12) {
                Image(systemName: record.type.systemImage)
                    .font(.title3)
                    .foregroundColor(Theme.accentCyan)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(record.title)
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Text(record.createdAt, format: .dateTime.month().day())
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary)
                    }

                    Text(record.summary)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }
            }
        }
    }
}
