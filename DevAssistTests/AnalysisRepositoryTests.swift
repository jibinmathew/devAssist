//
//  AnalysisRepositoryTests.swift
//  DevAssistTests
//
//  Created by Jibin on 2026-09-09.
//

import XCTest
import SwiftData
@testable import DevAssist

final class AnalysisRepositoryTests: XCTestCase {
    private var sut: AnalysisRepository!
    private var container: ModelContainer!

    override func setUp() async throws {
        try await super.setUp()
        let schema = Schema([AnalysisRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        sut = AnalysisRepository(modelContainer: container)
    }

    override func tearDown() async throws {
        sut = nil
        container = nil
        try await super.tearDown()
    }

    func test_saveAndFetchAll_persistsRecordInSwiftData() async throws {
        // Given
        let item = AnalysisResult(
            type: .architectureDesign,
            title: "Test Clean Arch",
            inputSnippet: "Input Spec",
            summary: "Summary Spec",
            detailedMarkdown: "# Architecture Overview",
            codePatch: "// Protocol",
            severityRating: .info,
            tags: ["Architecture", "MVVM"]
        )

        // When
        try await sut.save(item)
        let fetched = try await sut.fetchAll()

        // Then
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, item.id)
        XCTAssertEqual(fetched.first?.title, "Test Clean Arch")
    }

    func test_delete_removesRecordFromSwiftData() async throws {
        // Given
        let item = AnalysisResult(
            type: .testGeneration,
            title: "Test Spec",
            inputSnippet: "Code",
            summary: "Summary",
            detailedMarkdown: "Markdown"
        )
        try await sut.save(item)

        // When
        try await sut.delete(id: item.id)
        let fetched = try await sut.fetchAll()

        // Then
        XCTAssertTrue(fetched.isEmpty)
    }
}
