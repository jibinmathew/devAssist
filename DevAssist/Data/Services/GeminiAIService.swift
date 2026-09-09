//
//  GeminiAIService.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation

public final class GeminiAIService: AIServiceProtocol, @unchecked Sendable {
    private let mockFallbackService: MockAIService

    public init(mockFallbackService: MockAIService = MockAIService()) {
        self.mockFallbackService = mockFallbackService
    }

    public func analyze(prompt: String, type: AnalysisType, extraContext: String?) async throws -> AnalysisResult {
        guard let apiKey = KeychainManager.shared.getAPIKey(), !apiKey.isEmpty else {
            // Fallback to mock service gracefully if no API key configured
            return try await mockFallbackService.analyze(prompt: prompt, type: type, extraContext: extraContext)
        }

        let endpointString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)"
        guard let url = URL(string: endpointString) else {
            return try await mockFallbackService.analyze(prompt: prompt, type: type, extraContext: extraContext)
        }

        let systemInstruction = """
        You are DevPilot, an expert senior iOS software architect and Swift core developer.
        Perform a \(type.rawValue) based on the user's input.
        Respond with structured markdown including root cause/overview, detailed step-by-step breakdown, and an idiomatic Swift code patch block.
        """

        let userContent = """
        Context: \(extraContext ?? "None")
        Input Code / Requirements:
        \(prompt)
        """

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [["text": "\(systemInstruction)\n\n\(userContent)"]]
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let startTime = Date()

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return try await mockFallbackService.analyze(prompt: prompt, type: type, extraContext: extraContext)
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let firstCandidate = candidates.first,
               let content = firstCandidate["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let text = parts.first?["text"] as? String {

                return parseGeminiResponse(rawText: text, prompt: prompt, type: type, startTime: startTime)
            } else {
                return try await mockFallbackService.analyze(prompt: prompt, type: type, extraContext: extraContext)
            }
        } catch {
            return try await mockFallbackService.analyze(prompt: prompt, type: type, extraContext: extraContext)
        }
    }

    private func parseGeminiResponse(rawText: String, prompt: String, type: AnalysisType, startTime: Date) -> AnalysisResult {
        // Extract Swift code patch if present using markdown code block syntax
        var codePatch: String? = nil
        if let range = rawText.range(of: "```swift"),
           let endRange = rawText.range(of: "```", range: range.upperBound..<rawText.endIndex) {
            codePatch = String(rawText[range.upperBound..<endRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let summaryLines = rawText.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let summary = summaryLines.first?.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespaces) ?? "\(type.rawValue) completed."

        return AnalysisResult(
            type: type,
            title: "\(type.title) Result",
            inputSnippet: prompt,
            summary: String(summary.prefix(120)),
            detailedMarkdown: rawText,
            codePatch: codePatch,
            severityRating: type == .bugAnalysis ? .high : .info,
            tags: ["Gemini AI", "Swift", type.rawValue],
            createdAt: Date(),
            executionDurationSeconds: Date().timeIntervalSince(startTime)
        )
    }
}
