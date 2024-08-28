//
//  GameGroupingView.swift
//  ConnectionZ
//
//  Created by Michael Goodnow on 11/22/23.
//

import Foundation
import SwiftUI

struct GameGroupingView: View {
//    @Environment(LanguageSetting.self) var languageSettings

    var sectionName: String
    var dates: [String]
    var connectionsTOC: [Puzzles]
    var countryCode: String
    
    @State private var isExpanded: Bool
    
    init(sectionName: String, dates: [String], startCollapsed: Bool = false, resetGame: Bool = false, connectionsTOC: [Puzzles], countryCode: String) {
        self.sectionName = sectionName
        self.dates = dates
        self.connectionsTOC = connectionsTOC
        self.isExpanded = !startCollapsed
        self.countryCode = countryCode
    }
    
    var body: some View {
        
                
        if (!connectionsTOC.isEmpty) {
            // nah, just sort the TOC by hand...
            // let puzzles = connectionsTOC[0].puzzles.sorted{$0.puzzleName < $1.puzzleName}
            let puzzles = connectionsTOC[0].puzzles
            Section("Puzzles", isExpanded: $isExpanded) {
                ForEach(puzzles, id: \.self) { puzzle in
                    if countryCode == "ES" {
                        NavigationLink("Puzzle # \(puzzle.puzzleName)", value: puzzle.puzzleID)
                    } else {
                        NavigationLink("Puzzle # \(puzzle.puzzleName_EN ?? "asxcs")", value: puzzle.puzzleID)
                    }
                }
            }
        }
        
    }
}
