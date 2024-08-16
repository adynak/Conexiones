//
//  GuessHistory.swift
//  ConnectionZ
//
//  Created by al00p on 8/16/24.
//

import SwiftUI

struct GuessHistory: View {
    var guesses: [Guess]
    var body: some View {
        Text("Guesses").font(.title3)
        ScrollView {
            Grid(alignment: .leading) {
                ForEach(Array(guesses.enumerated()), id: \.offset) {
                    i, guess in
                    GuessView(i: i, guess: guess)
                }
            }.padding()
        }
        .defaultScrollAnchor(.top)
        .frame(maxWidth: 500, maxHeight: 130)
        .background(
            RoundedRectangle(
                cornerSize: CGSize(width: 10, height: 10)
            )
            .fill(Color.secondaryBackground)
        )
    }
}

struct GuessHistoryPreview : View {
    
    var body: some View {
        
        let guesses: [Guess] = [
            Guess(words: Set(["RADIOLAB", "UP FIRST", "WTF", "FORWARD"]), score: 1),
            Guess(words: Set(["UP", "DOWN", "LEFT", "RIGHT"]), score: 2),
            Guess(words: Set(["BLUE", "RED", "GREEN", "WHITE"]), score: 3),
            Guess(words: Set(["HOT", "COLD", "FREEZING", "BAKING"]), score: 4)
        ]
        
        GuessHistory(guesses: guesses)
    }
}

#Preview("EN"){
    GuessHistoryPreview()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("ES"){
    GuessHistoryPreview()
        .environment(\.locale, Locale(identifier: "ES"))
}

