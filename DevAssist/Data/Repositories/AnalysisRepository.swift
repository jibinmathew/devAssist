//
//  AnalysisRepository.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation
import SwiftData

@ModelActor
public actor AnalysisRepository: AnalysisRepositoryProtocol {

    public func save(_ result: AnalysisResult) async throws {
        let record = AnalysisRecord(from: result)
        modelContext.insert(record)
        try modelContext.save()
    }

    public func fetchAll() async throws -> [AnalysisResult] {
        let descriptor = FetchDescriptor<AnalysisRecord>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let records = try modelContext.fetch(descriptor)
        return records.map { $0.toDomain() }
    }

    public func fetch(byType type: AnalysisType) async throws -> [AnalysisResult] {
        let typeString = type.rawValue
        let predicate = #Predicate<AnalysisRecord> { record in
            record.typeRawValue == typeString
        }
        let descriptor = FetchDescriptor<AnalysisRecord>(predicate: predicate, sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let records = try modelContext.fetch(descriptor)
        return records.map { $0.toDomain() }
    }

    public func delete(id: UUID) async throws {
        let predicate = #Predicate<AnalysisRecord> { record in
            record.id == id
        }
        let descriptor = FetchDescriptor<AnalysisRecord>(predicate: predicate)
        if let record = try modelContext.fetch(descriptor).first {
            modelContext.delete(record)
            try modelContext.save()
        }
    }

    public func clearAll() async throws {
        try modelContext.delete(model: AnalysisRecord.self)
        try modelContext.save()
    }
}
