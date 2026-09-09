//
//  AnalysisRecord.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation
import SwiftData

@Model
public final class AnalysisRecord {
    @Attribute(.unique) public var id: UUID
    public var typeRawValue: String
    public var title: String
    public var inputSnippet: String
    public var summary: String
    public var detailedMarkdown: String
    public var codePatch: String?
    public var severityRawValue: String
    public var tagsData: String // Store JSON string array
    public var createdAt: Date
    public var executionDurationSeconds: Double

    public init(
        id: UUID = UUID(),
        typeRawValue: String,
        title: String,
        inputSnippet: String,
        summary: String,
        detailedMarkdown: String,
        codePatch: String? = nil,
        severityRawValue: String = "Info",
        tagsData: String = "[]",
        createdAt: Date = Date(),
        executionDurationSeconds: Double = 0.0
    ) {
        self.id = id
        self.typeRawValue = typeRawValue
        self.title = title
        self.inputSnippet = inputSnippet
        self.summary = summary
        self.detailedMarkdown = detailedMarkdown
        self.codePatch = codePatch
        self.severityRawValue = severityRawValue
        self.tagsData = tagsData
        self.createdAt = createdAt
        self.executionDurationSeconds = executionDurationSeconds
    }

    public convenience init(from result: AnalysisResult) {
        let jsonTags = (try? String(data: JSONEncoder().encode(result.tags), encoding: .utf8)) ?? "[]"
        self.init(
            id: result.id,
            typeRawValue: result.type.rawValue,
            title: result.title,
            inputSnippet: result.inputSnippet,
            summary: result.summary,
            detailedMarkdown: result.detailedMarkdown,
            codePatch: result.codePatch,
            severityRawValue: result.severityRating.rawValue,
            tagsData: jsonTags,
            createdAt: result.createdAt,
            executionDurationSeconds: result.executionDurationSeconds
        )
    }

    public func toDomain() -> AnalysisResult {
        let type = AnalysisType(rawValue: typeRawValue) ?? .bugAnalysis
        let severity = AnalysisResult.SeverityLevel(rawValue: severityRawValue) ?? .info
        let tags = (try? JSONDecoder().decode([String].self, from: Data(tagsData.utf8))) ?? []

        return AnalysisResult(
            id: id,
            type: type,
            title: title,
            inputSnippet: inputSnippet,
            summary: summary,
            detailedMarkdown: detailedMarkdown,
            codePatch: codePatch,
            severityRating: severity,
            tags: tags,
            createdAt: createdAt,
            executionDurationSeconds: executionDurationSeconds
        )
    }
}
