//
//  GenerateTestsUseCase.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public final class GenerateTestsUseCase: Sendable {
    private let aiService: AIServiceProtocol
    private let repository: AnalysisRepositoryProtocol

    public init(aiService: AIServiceProtocol, repository: AnalysisRepositoryProtocol) {
        self.aiService = aiService
        self.repository = repository
    }

    public func execute(sourceCode: String, framework: String) async throws -> AnalysisResult {
        guard !sourceCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "DevPilot", code: 400, userInfo: [NSLocalizedDescriptionKey: "Source code cannot be empty for test generation."])
        }
        let result = try await aiService.analyze(prompt: sourceCode, type: .testGeneration, extraContext: "Framework: \(framework)")
        try await repository.save(result)
        return result
    }
}
