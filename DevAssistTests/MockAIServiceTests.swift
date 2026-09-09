//
//  MockAIServiceTests.swift
//  DevAssistTests
//
//  Created by Jibin on 2026-09-09.
//

import XCTest
@testable import DevAssist

final class MockAIServiceTests: XCTestCase {
    private var sut: MockAIService!

    override func setUp() {
        super.setUp()
        sut = MockAIService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_analyze_bugAnalysis_returnsCriticalSeverity() async throws {
        // Given
        let prompt = "DispatchQueue.global().async { self.title = 'Test' }"

        // When
        let result = try await sut.analyze(prompt: prompt, type: .bugAnalysis, extraContext: nil)

        // Then
        XCTAssertEqual(result.type, .bugAnalysis)
        XCTAssertEqual(result.severityRating, .critical)
        XCTAssertFalse(result.summary.isEmpty)
        XCTAssertNotNil(result.codePatch)
        XCTAssertTrue(result.tags.contains("MainActor"))
    }

    func test_analyze_architectureDesign_returnsBlueprint() async throws {
        // Given
        let prompt = "Build clean iOS offline payment checkout"

        // When
        let result = try await sut.analyze(prompt: prompt, type: .architectureDesign, extraContext: nil)

        // Then
        XCTAssertEqual(result.type, .architectureDesign)
        XCTAssertTrue(result.tags.contains("Clean Architecture"))
        XCTAssertNotNil(result.codePatch)
    }

    func test_analyze_testGeneration_returnsUnitTestSuite() async throws {
        // Given
        let prompt = "func login() async throws -> User"

        // When
        let result = try await sut.analyze(prompt: prompt, type: .testGeneration, extraContext: nil)

        // Then
        XCTAssertEqual(result.type, .testGeneration)
        XCTAssertTrue(result.tags.contains("XCTest"))
        XCTAssertNotNil(result.codePatch)
    }

    func test_analyze_codeReview_returnsHighSeverityReview() async throws {
        // Given
        let prompt = "var cache = [String: Any]()"

        // When
        let result = try await sut.analyze(prompt: prompt, type: .codeReview, extraContext: nil)

        // Then
        XCTAssertEqual(result.type, .codeReview)
        XCTAssertEqual(result.severityRating, .high)
        XCTAssertNotNil(result.codePatch)
    }
}
