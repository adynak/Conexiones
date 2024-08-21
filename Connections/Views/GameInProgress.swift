//
//  GameInProgress.swift
//  Conexiones
//
//  Created by al00p on 8/20/24.
//

import SwiftUI

struct GameInProgress: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var game: Game
        
    var body: some View {
        
        let gameComplete = game.guesses.filter({$0.score == 4}).count == 4
        
        GeometryReader{ geo in
            let containerWidth = geo.size.width
            
            VStack{
                HStack (spacing: 5){
                    Text("Puzzle")
                    Text(verbatim: "\(game.date)")
                }
                .foregroundColor(Color("textDarkLight"))
                
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

struct GameInProgressPreviews : View {
    
    var locale: String
    
    var body: some View {
        let game = Game(id: 1000, date: "Unidad 6.1", words: [], groups: [])
        
        GameInProgress(game: game)
            .environment(\.locale, Locale(identifier: locale))
        
    }
}

#Preview("EN"){
    GameInProgressPreviews(locale: "EN")
}

#Preview("ES"){
    GameInProgressPreviews(locale: "ES")
}

#Preview("Light"){
    GameInProgressPreviews(locale: "EN")
        .preferredColorScheme(.light)
}

#Preview("Dark"){
    GameInProgressPreviews(locale: "EN")
        .preferredColorScheme(.dark)
}
