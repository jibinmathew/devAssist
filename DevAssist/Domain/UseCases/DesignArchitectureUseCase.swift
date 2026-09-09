//
//  DesignArchitectureUseCase.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public final class DesignArchitectureUseCase: Sendable {
    private let aiService: AIServiceProtocol
    private let repository: AnalysisRepositoryProtocol

    public init(aiService: AIServiceProtocol, repository: AnalysisRepositoryProtocol) {
        self.aiService = aiService
        self.repository = repository
    }

    public func execute(requirements: String, constraints: String?) async throws -> AnalysisResult {
        guard !requirements.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "DevPilot", code: 400, userInfo: [NSLocalizedDescriptionKey: "System requirements description cannot be empty."])
        }
        let result = try await aiService.analyze(prompt: requirements, type: .architectureDesign, extraContext: constraints)
        try await repository.save(result)
        return result
    }
}
