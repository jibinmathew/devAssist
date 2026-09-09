//
//  GlassCard.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct GlassCard<Content: View>: View {
    private let content: Content
    private let cornerRadius: CGFloat
    private let padding: CGFloat

    public init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(Theme.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Theme.borderGlass, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
    }
}

public extension View {
    func glassCardStyle(cornerRadius: CGFloat = 16, padding: CGFloat = 16) -> some View {
        GlassCard(cornerRadius: cornerRadius, padding: padding) {
            self
        }
    }
}
