//
//  ReviewCodeUseCase.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public final class ReviewCodeUseCase: Sendable {
    private let aiService: AIServiceProtocol
    private let repository: AnalysisRepositoryProtocol

    public init(aiService: AIServiceProtocol, repository: AnalysisRepositoryProtocol) {
        self.aiService = aiService
        self.repository = repository
    }

    public func execute(codeOrDiff: String, focusAreas: String?) async throws -> AnalysisResult {
        guard !codeOrDiff.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "DevPilot", code: 400, userInfo: [NSLocalizedDescriptionKey: "Code or diff cannot be empty."])
        }
        let result = try await aiService.analyze(prompt: codeOrDiff, type: .codeReview, extraContext: focusAreas)
        try await repository.save(result)
        return result
    }
}
