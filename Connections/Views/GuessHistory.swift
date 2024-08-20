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
//        Text("Guesses").font(.title3)
        ScrollView {
            Text("Guesses").font(.title3)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))

            Grid(alignment: .leading) {
                ForEach(Array(guesses.enumerated()), id: \.offset) {
                    i, guess in
                    GuessRow(i: i, guess: guess)
                }
            }
//            .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
        }
        .defaultScrollAnchor(.top)
        .frame(maxWidth: 500, maxHeight: 150)
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

