//
//  ContentView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let repository = AnalysisRepository(modelContainer: modelContext.container)
        HomeView(repository: repository)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: AnalysisRecord.self, inMemory: true)
}
