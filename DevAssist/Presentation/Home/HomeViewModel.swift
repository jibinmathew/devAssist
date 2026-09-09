//
//  HomeViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public private(set) var recentRecords: [AnalysisResult] = []
    @Published public private(set) var totalAnalysesCount: Int = 0
    @Published public private(set) var bugCount: Int = 0
    @Published public private(set) var archCount: Int = 0
    @Published public private(set) var testCount: Int = 0
    @Published public private(set) var reviewCount: Int = 0
    @Published public private(set) var isLoading: Bool = false

    private let repository: AnalysisRepositoryProtocol

    public init(repository: AnalysisRepositoryProtocol) {
        self.repository = repository
    }

    public func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let all = try await repository.fetchAll()
            self.recentRecords = Array(all.prefix(5))
            self.totalAnalysesCount = all.count
            self.bugCount = all.filter { $0.type == .bugAnalysis }.count
            self.archCount = all.filter { $0.type == .architectureDesign }.count
            self.testCount = all.filter { $0.type == .testGeneration }.count
            self.reviewCount = all.filter { $0.type == .codeReview }.count
        } catch {
            print("Failed to fetch records: \(error)")
        }
    }
}
