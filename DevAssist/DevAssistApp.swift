//
//  DevAssistApp.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import SwiftData

@main
struct DevAssistApp: App {
    let sharedModelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                AnalysisRecord.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create SwiftData ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            let repository = AnalysisRepository(modelContainer: sharedModelContainer)
            HomeView(repository: repository)
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
