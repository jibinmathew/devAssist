//
//  StatusBadge.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct StatusBadge: View {
    public let text: String
    public let color: Color
    public let systemImage: String?

    public init(text: String, color: Color = Theme.accentIndigo, systemImage: String? = nil) {
        self.text = text
        self.color = color
        self.systemImage = systemImage
    }

    public var body: some View {
        HStack(spacing: 4) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.caption2)
            }
            Text(text)
                .font(.caption2)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.4), lineWidth: 1)
        )
    }
}
