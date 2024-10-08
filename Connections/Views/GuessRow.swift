//
//  GuessView.swift
//  ConnectionZ
//
//  Created by al00p on 8/16/24.
//

import SwiftUI

struct GuessRow: View {
    
    @Environment(LanguageSetting.self) var languageSettings

    let i: Int
    let guess: Guess
    
    var icon: String {
        if guess.score == 4 {
            return "4.square.fill"
        } else if guess.score == 3 {
            return "3.square"
        } else if guess.score == 2 {
            return "2.square"
        } else {
            return "0.square"
        }
    }
    
    var body: some View {
        GridRow {
            Label(guess.words.sorted().joined(separator: ", "), systemImage: icon)
        }
    }
}

struct GuessViewPreview : View {
    
    @State var languageSettings = LanguageSetting()

    var numberCorrect: Int
    
    var body: some View {
        let guess: Guess =
            Guess(words: Set(["HE", "SHE", "THEY", "THEM"]), score: numberCorrect)
        
        GuessRow(i: 1, guess: guess)
            .environment(languageSettings)
            .environment(\.locale, languageSettings.locale)
    }
}

#Preview("1") {
    GuessViewPreview(numberCorrect: 1)
}

#Preview("2") {
    GuessViewPreview(numberCorrect: 2)
}

#Preview("3") {
    GuessViewPreview(numberCorrect: 3)
}

#Preview("4") {
    GuessViewPreview(numberCorrect: 4)
}
