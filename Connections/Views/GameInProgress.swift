//
//  GameInProgress.swift
//  Conexiones
//
//  Created by al00p on 8/20/24.
//

import SwiftUI

struct GameInProgress: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(LanguageSetting.self) var languageSettings
    
    
    var game: Game
    
    
    var body: some View {
        
        let gameComplete = game.guesses.filter({$0.score == 4}).count == 4
    
        GeometryReader{ geo in
            let containerWidth = geo.size.width
            
            VStack{
                HStack (spacing: 2){
                    Text("Puzzle #")
                    Text(verbatim: "\(game.id)")
                }
                .foregroundColor(Color("textDark"))
                
                HStack{
                    if gameComplete {
                        Text("Game Complete")
                    } else {
                        Text("Game in Progress")
                    }
                }
                .foregroundColor(Color("textDark"))
                
                VStack(spacing: 5) {
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack{
                            if gameComplete {
                                Text("View Solution")
                            } else {
                                Text("Continue")
                            }
                        }
                        .frame(width: containerWidth * 1.0, height: 40)
                        .foregroundColor(Color("textLight"))
                        .background(Color("mainColor"))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        game.reset()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Start Over")
                            .frame(width: containerWidth * 1.0, height: 40)
                            .foregroundColor(Color("textDarkLight"))
                            .background(Color("medium"))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .padding()
        .frame(height: 170)
        .background(Color("edit"))
        .cornerRadius(20)
        .shadow(radius: 20 )
        
    }
}

#Preview("EN"){
    let game = Game(id: 1000, date: "1000", words: [], groups: [])
    GameInProgress(game: game)
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("ES"){
    let game = Game(id: 1000, date: "1000", words: [], groups: [])
    GameInProgress(game: game)
        .environment(\.locale, Locale(identifier: "ES"))
}


