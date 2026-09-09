//
//  Item.swift
//  DevAssist
//
//  Created by Jibin on 2026-09-09.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
