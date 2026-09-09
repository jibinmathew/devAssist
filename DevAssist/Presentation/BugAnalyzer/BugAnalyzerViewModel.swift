//
//  BugAnalyzerViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class BugAnalyzerViewModel: ObservableObject {
    @Published public var inputCode: String = ""
    @Published public var logsContext: String = ""
    @Published public private(set) var result: AnalysisResult?
    @Published public private(set) var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let useCase: AnalyzeBugUseCase

    public init(useCase: AnalyzeBugUseCase) {
        self.useCase = useCase
    }

    public func analyzeBug() async {
        guard !inputCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter a crash log or Swift code snippet to analyze."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let res = try await useCase.execute(snippet: inputCode, logs: logsContext.isEmpty ? nil : logsContext)
            self.result = res
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func loadSampleSnippet() {
        inputCode = """
        // 🐛 Sample Bug: Mutating UI State from Background Context
        final class UserProfileViewModel: ObservableObject {
            @Published var username: String = ""

            func loadUser() {
                DispatchQueue.global().async {
                    // ❌ Thread safety violation: mutating @Published on background thread
                    self.username = "Jibin"
                }
            }
        }
        """
        logsContext = "Thread 5: Fatal Exception: NSInternalInconsistencyException - Modifying State from Background Thread."
    }
}
