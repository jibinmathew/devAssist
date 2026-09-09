//
//  AIServiceProtocol.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public protocol AIServiceProtocol: Sendable {
    func analyze(prompt: String, type: AnalysisType, extraContext: String?) async throws -> AnalysisResult
}
