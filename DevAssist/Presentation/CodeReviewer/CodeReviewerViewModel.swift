//
//  CodeReviewerViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class CodeReviewerViewModel: ObservableObject {
    @Published public var codeOrDiffInput: String = ""
    @Published public var focusAreaInput: String = ""
    @Published public private(set) var result: AnalysisResult?
    @Published public private(set) var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let useCase: ReviewCodeUseCase

    public init(useCase: ReviewCodeUseCase) {
        self.useCase = useCase
    }

    public func reviewCode() async {
        guard !codeOrDiffInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter Swift code or git diff for review."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let res = try await useCase.execute(codeOrDiff: codeOrDiffInput, focusAreas: focusAreaInput.isEmpty ? nil : focusAreaInput)
            self.result = res
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func loadSampleDiff() {
        codeOrDiffInput = """
        class DataManager {
            static let shared = DataManager()
            var cache = [String: Any]()

            func fetchData(url: URL, completion: @escaping (Data?) -> Void) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    // 🔴 Retain cycle and unsafe global state access
                    self.cache[url.absoluteString] = data
                    completion(data)
                }.resume()
            }
        }
        """
        focusAreaInput = "Memory Leaks, Retain Cycles, Swift Concurrency Migration"
    }
}
