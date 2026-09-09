//
//  Theme.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public enum Theme {
    public static let bgGradient = LinearGradient(
        colors: [Color(hex: "0D1117"), Color(hex: "161B22"), Color(hex: "0D1117")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let accentIndigo = Color(hex: "6366F1")
    public static let accentCyan = Color(hex: "06B6D4")
    public static let cardBg = Color(hex: "1F2937").opacity(0.7)
    public static let borderGlass = Color.white.opacity(0.12)
    public static let textPrimary = Color.white
    public static let textSecondary = Color(hex: "9CA3AF")
    public static let bugRed = Color(hex: "EF4444")
    public static let archBlue = Color(hex: "3B82F6")
    public static let testPurple = Color(hex: "8B5CF6")
    public static let reviewEmerald = Color(hex: "10B981")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
