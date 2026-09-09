//
//  PrimaryButton.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct PrimaryButton: View {
    public let title: String
    public let systemImage: String?
    public let isLoading: Bool
    public let gradient: LinearGradient
    public let action: () -> Void

    public init(
        title: String,
        systemImage: String? = nil,
        isLoading: Bool = false,
        gradient: LinearGradient = LinearGradient(colors: [Theme.accentIndigo, Theme.accentCyan], startPoint: .leading, endPoint: .trailing),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isLoading = isLoading
        self.gradient = gradient
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .font(.headline)
                    }
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Theme.accentIndigo.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .disabled(isLoading)
    }
}
