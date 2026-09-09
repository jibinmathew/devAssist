//
//  HistoryViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class HistoryViewModel: ObservableObject {
    @Published public private(set) var records: [AnalysisResult] = []
    @Published public var selectedFilter: AnalysisType? = nil
    @Published public var searchText: String = ""
    @Published public private(set) var isLoading: Bool = false

    private let repository: AnalysisRepositoryProtocol

    public init(repository: AnalysisRepositoryProtocol) {
        self.repository = repository
    }

    public var filteredRecords: [AnalysisResult] {
        records.filter { record in
            let matchesType = (selectedFilter == nil || record.type == selectedFilter)
            let matchesSearch = searchText.isEmpty ||
                record.title.localizedCaseInsensitiveContains(searchText) ||
                record.summary.localizedCaseInsensitiveContains(searchText) ||
                record.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            return matchesType && matchesSearch
        }
    }

    public func loadRecords() async {
        isLoading = true
        defer { isLoading = false }

        do {
            self.records = try await repository.fetchAll()
        } catch {
            print("Failed to fetch history: \(error)")
        }
    }

    public func delete(id: UUID) async {
        do {
            try await repository.delete(id: id)
            await loadRecords()
        } catch {
            print("Failed to delete record: \(error)")
        }
    }

    public func clearAll() async {
        do {
            try await repository.clearAll()
            await loadRecords()
        } catch {
            print("Failed to clear history: \(error)")
        }
    }
}
