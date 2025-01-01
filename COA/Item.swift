//
//  Item.swift
//  COA
//
//  Created by h2025002 on 2025/1/1.
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
