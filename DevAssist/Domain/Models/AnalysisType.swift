//
//  AnalysisType.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public enum AnalysisType: String, Codable, CaseIterable, Identifiable, Sendable {
    case bugAnalysis = "Bug Analysis"
    case architectureDesign = "Architecture Design"
    case testGeneration = "Test Generation"
    case codeReview = "Code Review"

    public var id: String { rawValue }

    public var systemImage: String {
        switch self {
        case .bugAnalysis:
            return "ant.fill"
        case .architectureDesign:
            return "square.3.layers.3d.down.right"
        case .testGeneration:
            return "vial.viewfinder"
        case .codeReview:
            return "text.magnifyingglass"
        }
    }

    public var title: String {
        switch self {
        case .bugAnalysis:
            return "Bug Analyzer"
        case .architectureDesign:
            return "Architecture Designer"
        case .testGeneration:
            return "Test Suite Generator"
        case .codeReview:
            return "Code Reviewer"
        }
    }

    public var subtitle: String {
        switch self {
        case .bugAnalysis:
            return "Diagnose crash logs, stack traces, & logic bugs"
        case .architectureDesign:
            return "Draft Clean Architecture & component specs"
        case .testGeneration:
            return "Generate unit tests with XCTest & Swift Testing"
        case .codeReview:
            return "Audit performance, leaks, & Swift best practices"
        }
    }
}
