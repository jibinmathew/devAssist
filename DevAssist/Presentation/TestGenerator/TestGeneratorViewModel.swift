//
//  TestGeneratorViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class TestGeneratorViewModel: ObservableObject {
    @Published public var sourceCodeInput: String = ""
    @Published public var selectedFramework: String = "XCTest"
    @Published public private(set) var result: AnalysisResult?
    @Published public private(set) var isLoading: Bool = false
    @Published public var errorMessage: String?

    public let frameworks = ["XCTest", "Swift Testing"]

    private let useCase: GenerateTestsUseCase

    public init(useCase: GenerateTestsUseCase) {
        self.useCase = useCase
    }

    public func generateTests() async {
        guard !sourceCodeInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please paste source code to generate unit tests for."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let res = try await useCase.execute(sourceCode: sourceCodeInput, framework: selectedFramework)
            self.result = res
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func loadSampleCode() {
        sourceCodeInput = """
        // Swift Class to Test
        final class OrderViewModel: ObservableObject {
            @Published private(set) var order: Order?
            @Published private(set) var isLoading: Bool = false
            @Published private(set) var errorMessage: String?

            private let useCase: FetchOrderUseCaseProtocol

            init(useCase: FetchOrderUseCaseProtocol) {
                self.useCase = useCase
            }

            func loadOrder(id: String) async {
                isLoading = true
                defer { isLoading = false }
                
                do {
                    self.order = try await useCase.execute(orderId: id)
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        """
    }
}
