//
//  AnalysisResult.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public struct AnalysisResult: Identifiable, Codable, Sendable, Hashable {
    public let id: UUID
    public let type: AnalysisType
    public let title: String
    public let inputSnippet: String
    public let summary: String
    public let detailedMarkdown: String
    public let codePatch: String?
    public let severityRating: SeverityLevel
    public let tags: [String]
    public let createdAt: Date
    public let executionDurationSeconds: Double

    public enum SeverityLevel: String, Codable, CaseIterable, Sendable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
        case info = "Info"

        public var colorName: String {
            switch self {
            case .low: return "green"
            case .medium: return "yellow"
            case .high: return "orange"
            case .critical: return "red"
            case .info: return "blue"
            }
        }
    }

    public init(
        id: UUID = UUID(),
        type: AnalysisType,
        title: String,
        inputSnippet: String,
        summary: String,
        detailedMarkdown: String,
        codePatch: String? = nil,
        severityRating: SeverityLevel = .info,
        tags: [String] = [],
        createdAt: Date = Date(),
        executionDurationSeconds: Double = 0.0
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.inputSnippet = inputSnippet
        self.summary = summary
        self.detailedMarkdown = detailedMarkdown
        self.codePatch = codePatch
        self.severityRating = severityRating
        self.tags = tags
        self.createdAt = createdAt
        self.executionDurationSeconds = executionDurationSeconds
    }
}
