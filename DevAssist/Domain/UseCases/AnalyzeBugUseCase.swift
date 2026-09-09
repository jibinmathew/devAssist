//
//  AnalyzeBugUseCase.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public final class AnalyzeBugUseCase: Sendable {
    private let aiService: AIServiceProtocol
    private let repository: AnalysisRepositoryProtocol

    public init(aiService: AIServiceProtocol, repository: AnalysisRepositoryProtocol) {
        self.aiService = aiService
        self.repository = repository
    }

    public func execute(snippet: String, logs: String?) async throws -> AnalysisResult {
        guard !snippet.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "DevPilot", code: 400, userInfo: [NSLocalizedDescriptionKey: "Input stack trace or code snippet cannot be empty."])
        }
        let result = try await aiService.analyze(prompt: snippet, type: .bugAnalysis, extraContext: logs)
        try await repository.save(result)
        return result
    }
}
