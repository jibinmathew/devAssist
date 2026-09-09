//
//  ArchDesignerViewModel.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import Combine

@MainActor
public final class ArchDesignerViewModel: ObservableObject {
    @Published public var requirementsInput: String = ""
    @Published public var constraintsInput: String = ""
    @Published public private(set) var result: AnalysisResult?
    @Published public private(set) var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let useCase: DesignArchitectureUseCase

    public init(useCase: DesignArchitectureUseCase) {
        self.useCase = useCase
    }

    public func generateArchitecture() async {
        guard !requirementsInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter system requirements."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let res = try await useCase.execute(requirements: requirementsInput, constraints: constraintsInput.isEmpty ? nil : constraintsInput)
            self.result = res
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func loadSampleRequirements() {
        requirementsInput = "Build an E-Commerce iOS Checkout flow with offline order drafting in SwiftData, payment processing via REST API, and order status updates using Swift Concurrency."
        constraintsInput = "Clean Architecture, MVVM presentation, protocol-based repositories, strictly no third-party network libraries."
    }
}
