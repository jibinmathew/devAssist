//
//  BugAnalyzerViewModelTests.swift
//  DevAssistTests
//
//  Created by Jibin on 2026-09-09.
//

import XCTest
import SwiftData
@testable import DevAssist

@MainActor
final class BugAnalyzerViewModelTests: XCTestCase {
    private var sut: BugAnalyzerViewModel!
    private var mockService: MockAIService!
    private var repository: AnalysisRepository!
    private var container: ModelContainer!

    override func setUp() async throws {
        try await super.setUp()
        let schema = Schema([AnalysisRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])

        repository = AnalysisRepository(modelContainer: container)
        mockService = MockAIService()

        let useCase = AnalyzeBugUseCase(aiService: mockService, repository: repository)
        sut = BugAnalyzerViewModel(useCase: useCase)
    }

    override func tearDown() async throws {
        sut = nil
        mockService = nil
        repository = nil
        container = nil
        try await super.tearDown()
    }

    func test_analyzeBug_withEmptyInput_setsErrorMessage() async {
        // Given
        sut.inputCode = ""

        // When
        await sut.analyzeBug()

        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.result)
    }

    func test_analyzeBug_withValidInput_populatesResultAndPersists() async throws {
        // Given
        sut.inputCode = "DispatchQueue.global().async { self.name = 'Test' }"

        // When
        await sut.analyzeBug()

        // Then
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotNil(sut.result)
        XCTAssertEqual(sut.result?.type, .bugAnalysis)

        // Verify persistence in SwiftData
        let savedRecords = try await repository.fetchAll()
        XCTAssertEqual(savedRecords.count, 1)
        XCTAssertEqual(savedRecords.first?.type, .bugAnalysis)
    }
}
