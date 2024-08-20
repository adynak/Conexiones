//
//  GameGroupingView.swift
//  ConnectionZ
//
//  Created by Michael Goodnow on 11/22/23.
//

import Foundation
import SwiftUI

struct GameGroupingView: View {
    var sectionName: String
    var dates: [String]
    var connectionsTOC: [Puzzles]
    
    @State private var isExpanded: Bool
    
    init(sectionName: String, dates: [String], startCollapsed: Bool = false, resetGame: Bool = false, connectionsTOC: [Puzzles]) {
        self.sectionName = sectionName
        self.dates = dates
        self.connectionsTOC = connectionsTOC
        self.isExpanded = !startCollapsed
    }
    
    var body: some View {
        if (!connectionsTOC.isEmpty) {
            Section(sectionName, isExpanded: $isExpanded) {
                ForEach(connectionsTOC[0].puzzles, id: \.self) { puzzle in
                    NavigationLink("Puzzle # \(puzzle.puzzleID)", value: puzzle.puzzleID)
                }
            }
        }

    }
}
