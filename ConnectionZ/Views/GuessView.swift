//
//  GuessView.swift
//  ConnectionZ
//
//  Created by al00p on 8/16/24.
//

import SwiftUI

struct GuessView: View {
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
            return "square"
        }
    }
    
    var body: some View {
        GridRow {
            Label(guess.words.sorted().joined(separator: ", "), systemImage: icon)
        }
    }
}

//#Preview {
//    GuessView(i: 1, guess: <#Guess#>)
//}
