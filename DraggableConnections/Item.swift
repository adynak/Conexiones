//
//  Item.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/9/23.
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
