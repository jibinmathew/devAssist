//
//  MockAIService.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public final class MockAIService: AIServiceProtocol, @unchecked Sendable {
    public init() {}

    public func analyze(prompt: String, type: AnalysisType, extraContext: String?) async throws -> AnalysisResult {
        // Simulate realistic network / AI inference latency
        try await Task.sleep(nanoseconds: 800_000_000)

        let startTime = Date()

        switch type {
        case .bugAnalysis:
            return createBugAnalysisResult(prompt: prompt, context: extraContext, startTime: startTime)
        case .architectureDesign:
            return createArchitectureResult(prompt: prompt, context: extraContext, startTime: startTime)
        case .testGeneration:
            return createTestResult(prompt: prompt, context: extraContext, startTime: startTime)
        case .codeReview:
            return createCodeReviewResult(prompt: prompt, context: extraContext, startTime: startTime)
        }
    }

    private func createBugAnalysisResult(prompt: String, context: String?, startTime: Date) -> AnalysisResult {
        let patch = """
        // 🛠️ Fixed Implementation (Thread Safety & MainActor Dispatch)
        @MainActor
        final class UserDataViewModel: ObservableObject {
            @Published private(set) var userProfile: UserProfile?
            @Published private(set) var isLoading = false
            
            private let userRepository: UserRepositoryProtocol

            init(userRepository: UserRepositoryProtocol) {
                self.userRepository = userRepository
            }

            func fetchProfile(for userId: String) async {
                isLoading = true
                defer { isLoading = false }
                
                do {
                    let profile = try await userRepository.getUser(id: userId)
                    self.userProfile = profile
                } catch {
                    print("❌ Fetch failed: \\(error)")
                }
            }
        }
        """

        let markdown = """
        ### 🔍 Crash & Bug Diagnostics Report

        #### 1. Root Cause Analysis
        The provided code exhibits a **`EXC_BAD_INSTRUCTION`** or **UI Thread Violation** caused by mutating state from a background concurrency context without dispatching to `@MainActor`. Additionally, unsafe implicit unwrapping on optional state led to a crash during data hydration.

        #### 2. Risk & Impact Level
        - **Severity**: `Critical`
        - **Impact**: Application panic / unexpected crashes during rapid user interactions or network retries.

        #### 3. Recommended Remediation
        1. **Annotate ViewModel with `@MainActor`**: Guarantees all `@Published` state mutations happen safely on the main thread.
        2. **Use Structured Concurrency (`async/await`)**: Replaces callback-based API calls with `Task` and `defer` handlers.
        3. **Safely Unwrap Repositories**: Inject dependencies using protocols to prevent deadlocks and allow unit testing.

        #### 4. Summary Checklist
        - [x] `@MainActor` isolation verified
        - [x] Implicit unwraps replaced with safe optional binding
        - [x] Unit test stub created for error path
        """

        return AnalysisResult(
            type: .bugAnalysis,
            title: "Thread Violation & State Crash Diagnostic",
            inputSnippet: prompt,
            summary: "Identified unsafe background thread mutation of UI state and potential optional unwrap crash.",
            detailedMarkdown: markdown,
            codePatch: patch,
            severityRating: .critical,
            tags: ["MainActor", "Concurrency", "EXC_BAD_INSTRUCTION", "SwiftUI"],
            createdAt: Date(),
            executionDurationSeconds: Date().timeIntervalSince(startTime)
        )
    }

    private func createArchitectureResult(prompt: String, context: String?, startTime: Date) -> AnalysisResult {
        let codePatch = """
        // 🏛️ Clean Architecture Component Layout
        
        // --- DOMAIN LAYER ---
        public protocol FetchOrderUseCaseProtocol: Sendable {
            func execute(orderId: String) async throws -> Order
        }

        public final class FetchOrderUseCase: FetchOrderUseCaseProtocol {
            private let repository: OrderRepositoryProtocol
            public init(repository: OrderRepositoryProtocol) {
                self.repository = repository
            }
            public func execute(orderId: String) async throws -> Order {
                try await repository.getOrder(id: orderId)
            }
        }

        // --- DATA LAYER ---
        public protocol OrderRepositoryProtocol: Sendable {
            func getOrder(id: String) async throws -> Order
        }

        public final class OrderRepository: OrderRepositoryProtocol {
            private let remoteDataSource: RemoteDataSourceProtocol
            private let localStore: SwiftDataStore
            
            public init(remoteDataSource: RemoteDataSourceProtocol, localStore: SwiftDataStore) {
                self.remoteDataSource = remoteDataSource
                self.localStore = localStore
            }
            
            public func getOrder(id: String) async throws -> Order {
                if let cached = try await localStore.fetchOrder(id: id) { return cached }
                let remote = try await remoteDataSource.fetchOrder(id: id)
                try await localStore.save(order: remote)
                return remote
            }
        }
        """

        let markdown = """
        ### 🏗️ Proposed Software Architecture Blueprint

        #### 1. High-Level System Topology
        This design strictly follows **Clean Architecture** principles, enforcing unidirectionality and complete decoupling between presentation logic and data persistence layers.

        ```
        [ Presentation (SwiftUI) ] ---> [ Domain (Use Cases) ] <--- [ Data (Repositories) ]
                                                                          │
                                                                 ┌────────┴────────┐
                                                                 ▼                 ▼
                                                            (SwiftData)       (REST API)
        ```

        #### 2. Key Component Specification
        - **Domain Layer**: Contains pure business logic (`Entities`, `UseCases`, and repository interfaces). Completely framework agnostic.
        - **Data Layer**: Implements repository protocols utilizing **SwiftData** for offline caching and **URLSession / REST** for remote synchronization.
        - **Presentation Layer**: Built with **SwiftUI + MVVM**, leveraging `@Observable` / `ObservableObject` and `@MainActor` binding.

        #### 3. Best Practices & Design Patterns
        - Protocol-Oriented Programming (POP) for dependency injection and easy unit test mocking.
        - Actor-based isolation for network request deduplication and local data caching.
        """

        return AnalysisResult(
            type: .architectureDesign,
            title: "Clean Architecture & Modular Design System",
            inputSnippet: prompt,
            summary: "Designed a 3-tier Clean Architecture layout with SwiftData caching and REST data sources.",
            detailedMarkdown: markdown,
            codePatch: codePatch,
            severityRating: .info,
            tags: ["Clean Architecture", "MVVM", "SwiftData", "Protocol-Oriented"],
            createdAt: Date(),
            executionDurationSeconds: Date().timeIntervalSince(startTime)
        )
    }

    private func createTestResult(prompt: String, context: String?, startTime: Date) -> AnalysisResult {
        let codePatch = """
        // 🧪 Unit Test Suite (Swift Testing / XCTest)
        import XCTest
        @testable import DevAssist

        final class OrderViewModelTests: XCTestCase {
            private var sut: OrderViewModel!
            private var mockUseCase: MockFetchOrderUseCase!

            override func setUp() {
                super.setUp()
                mockUseCase = MockFetchOrderUseCase()
                sut = OrderViewModel(fetchOrderUseCase: mockUseCase)
            }

            override func tearDown() {
                sut = nil
                mockUseCase = nil
                super.tearDown()
            }

            func test_fetchOrder_success_updatesOrderState() async throws {
                // Given
                let expectedOrder = Order(id: "123", amount: 99.99, status: .completed)
                mockUseCase.stubbedResult = .success(expectedOrder)

                // When
                await sut.loadOrder(id: "123")

                // Then
                XCTAssertEqual(sut.order?.id, "123")
                XCTAssertFalse(sut.isLoading)
                XCTAssertNil(sut.errorMessage)
            }

            func test_fetchOrder_failure_setsErrorMessage() async throws {
                // Given
                mockUseCase.stubbedResult = .failure(NSError(domain: "Network", code: 500))

                // When
                await sut.loadOrder(id: "999")

                // Then
                XCTAssertNil(sut.order)
                XCTAssertFalse(sut.isLoading)
                XCTAssertNotNil(sut.errorMessage)
            }
        }
        """

        let markdown = """
        ### 🧪 Test Suite Generation Report

        #### 1. Coverage Overview
        Generated comprehensive asynchronous unit tests using **XCTest** & modern **Swift Testing** paradigms.

        #### 2. Test Cases Included
        1. **Happy Path (`test_fetchOrder_success_updatesOrderState`)**: Verifies state transitions (`isLoading`, `order`) when Use Case succeeds.
        2. **Error Path (`test_fetchOrder_failure_setsErrorMessage`)**: Confirms error handling and message population on network failure.
        3. **Concurrency Safety Test**: Validates proper cancellation and task handling during rapid UI dismissals.

        #### 3. Mock Setup Guidelines
        Use the protocol-based mock implementation provided in the patch to simulate network conditions without live API calls.
        """

        return AnalysisResult(
            type: .testGeneration,
            title: "XCTest & Concurrency Test Suite",
            inputSnippet: prompt,
            summary: "Generated unit tests with mock stubs covering success, error, and concurrency paths.",
            detailedMarkdown: markdown,
            codePatch: codePatch,
            severityRating: .info,
            tags: ["XCTest", "Swift Testing", "Mocking", "Async/Await"],
            createdAt: Date(),
            executionDurationSeconds: Date().timeIntervalSince(startTime)
        )
    }

    private func createCodeReviewResult(prompt: String, context: String?, startTime: Date) -> AnalysisResult {
        let codePatch = """
        // 💡 Refactored Implementation with Concurrency & Memory Fixes
        final class ImageLoaderService {
            private let cache = NSCache<NSURL, UIImage>()

            func loadImage(from url: URL) async throws -> UIImage {
                // 1. Check in-memory cache
                if let cached = cache.object(forKey: url as NSURL) {
                    return cached
                }

                // 2. Fetch using structured concurrency
                let (data, response) = try await URLSession.shared.data(from: url)
                guard (response as? HTTPURLResponse)?.statusCode == 200,
                      let image = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }

                // 3. Cache and return
                cache.setObject(image, forKey: url as NSURL)
                return image
            }
        }
        """

        let markdown = """
        ### 💻 Automated Code Review & Performance Audit

        #### 1. Executive Summary
        Reviewed code for memory safety, concurrency correctness, and Swift style adherence. Found **2 high priority issues** and **1 performance optimization opportunity**.

        #### 2. Flagged Issues & Anti-Patterns
        - ⚠️ **Potential Memory Leak (Retain Cycle)**: Explicit self capture in escaping closure without `[weak self]`.
        - 🔴 **Thread Safety Hazard**: Non-isolated mutation of a shared Dictionary across concurrent threads. Replace with `NSCache` or an `actor`.
        - ⚡ **Performance Optimization**: Repeated regex allocation inside hot loop. Pre-compile `NSRegularExpression` statically.

        #### 3. Refactoring Roadmap
        1. Replace dictionary caching with `actor` or `NSCache`.
        2. Adopt `async/await` to remove nested closure callbacks.
        3. Add explicit `@Sendable` annotations on task closures.
        """

        return AnalysisResult(
            type: .codeReview,
            title: "Memory Safety & Performance Review",
            inputSnippet: prompt,
            summary: "Identified retain cycle vulnerability, non-thread-safe dictionary usage, and performance improvements.",
            detailedMarkdown: markdown,
            codePatch: codePatch,
            severityRating: .high,
            tags: ["Memory Leak", "Retain Cycle", "NSCache", "Code Audit"],
            createdAt: Date(),
            executionDurationSeconds: Date().timeIntervalSince(startTime)
        )
    }
}
