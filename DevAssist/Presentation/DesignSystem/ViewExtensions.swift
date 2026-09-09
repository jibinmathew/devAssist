//
//  ViewExtensions.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func inlineNavigationBarTitleMode() -> some View {
#if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
#else
        self
#endif
    }
}
