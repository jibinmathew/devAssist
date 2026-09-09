//
//  CodeEditorView.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public struct CodeEditorView: View {
    @Binding public var codeText: String
    public let placeholder: String
    public let isEditable: Bool
    public let minHeight: CGFloat
    @State private var copied: Bool = false

    public init(
        codeText: Binding<String>,
        placeholder: String = "// Paste Swift code, stack trace, or requirements...",
        isEditable: Bool = true,
        minHeight: CGFloat = 160
    ) {
        self._codeText = codeText
        self.placeholder = placeholder
        self.isEditable = isEditable
        self.minHeight = minHeight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(Color.red.opacity(0.8)).frame(width: 10, height: 10)
                    Circle().fill(Color.yellow.opacity(0.8)).frame(width: 10, height: 10)
                    Circle().fill(Color.green.opacity(0.8)).frame(width: 10, height: 10)
                }
                
                Text("Swift Snippet")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)

                Spacer()

                if !codeText.isEmpty {
                    Button(action: copyToClipboard) {
                        HStack(spacing: 4) {
                            Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                            Text(copied ? "Copied" : "Copy")
                        }
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(copied ? Color.green.opacity(0.2) : Color.white.opacity(0.1))
                        .foregroundColor(copied ? .green : Theme.textPrimary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)

            Divider().background(Theme.borderGlass)

            ZStack(alignment: .topLeading) {
                if codeText.isEmpty && isEditable {
                    Text(placeholder)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Theme.textSecondary.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }

                if isEditable {
                    TextEditor(text: $codeText)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Theme.textPrimary)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: minHeight)
                        .padding(.horizontal, 8)
                } else {
                    ScrollView {
                        Text(codeText)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(Theme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .frame(minHeight: minHeight, maxHeight: 300)
                }
            }
        }
        .background(Color(hex: "0F172A"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Theme.borderGlass, lineWidth: 1)
        )
    }

    private func copyToClipboard() {
#if os(iOS)
        UIPasteboard.general.string = codeText
#elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(codeText, forType: .string)
#endif
        withAnimation {
            copied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                copied = false
            }
        }
    }
}
