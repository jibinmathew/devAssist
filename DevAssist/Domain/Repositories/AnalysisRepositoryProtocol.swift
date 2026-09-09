//
//  AnalysisRepositoryProtocol.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public protocol AnalysisRepositoryProtocol: Sendable {
    func save(_ result: AnalysisResult) async throws
    func fetchAll() async throws -> [AnalysisResult]
    func fetch(byType type: AnalysisType) async throws -> [AnalysisResult]
    func delete(id: UUID) async throws
    func clearAll() async throws
}
