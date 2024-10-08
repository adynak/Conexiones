//
//  GameView.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/11/23.
//

import Foundation
import SwiftUI
import Drops

extension String: @retroactive Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

struct Tile: View {
    var word: String
    var selected: Bool
    var selectAction: () -> Void
    
    var borderWidth: CGFloat {
        return selected ? 4 : 0
    }
    var body: some View {
        Text(word)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .bold()
            .background(
                RoundedRectangle(
                    cornerSize: CGSize(width: 10, height: 10)
                )
                .fill(Color.secondaryBackground)
                .addBorder(Color.accentColor, width: borderWidth, cornerRadius: 10)
            ).onTapGesture(perform: selectAction)
        
    }
}

struct GameView: View {
    
    @State var selected = Set<String>()
    @State var shouldShowConfirmationDialog = false;
    @State var gameInProgress: Bool = false
    
    @Environment(LanguageSetting.self) var languageSettings
    
    let cols = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    var game: Game
    
    
    func select(word: String) {
        if selected.contains(word) {
            selected.remove(word)
        } else if selected.count < 4 {
            selected.insert(word)
        }
    }
    
    func isSelected(word: String) -> Bool {
        return selected.contains(word)
    }
        
    var body: some View {
        
        let gridWords = game.words
        
        NavigationStack {
            VStack {
//                if game.guesses.filter({$0.score != 4}).count > 0 {
//                    GuessHistory(guesses: game.guesses)
//                        .padding(EdgeInsets(top: 00, leading: 5, bottom: 20, trailing: 5))
//                }
                if game.isComplete {
                    Text("Complete!").font(.title2)
                } else {
                    VStack{
                        Text("Create four groups of four!").font(.title2)
                        Text("Drag to Reorder").font(.callout)
                    }
                }
                VStack(spacing: 8) {
                    CompletedGroups(groups: game.foundGroups)
                    LazyVGrid(columns: cols, spacing: 8, content: {
                        ReorderableForEach(items: gridWords) { word in
                            Tile(word: word, selected: isSelected(word: word), selectAction: {
                                select(word: word)
                            })
                        } moveAction: { from, to in
                            game.words.move(fromOffsets: from, toOffset: to)
                        }
                    })
                }
//                .frame(minWidth: 300, maxWidth: 500, minHeight: 300, maxHeight: 500)
//                .aspectRatio(1, contentMode: .fit)
//                .layoutPriority(1)
                HStack {
                    Spacer()
                    
                    if game.isComplete {
                        Button("Reset Game") {
                            shouldShowConfirmationDialog = true
                        }
                        .buttonStyle(ConnectionsButtonStyle(fgColor: "textDark", bgColor: "tasted"))
                        .confirmationDialog(
                            "Resetting will delete this game's history.",
                            isPresented: $shouldShowConfirmationDialog
                        ) {
                            Button("Reset Game", role: .destructive) {
                                game.reset()
                            }
                            .keyboardShortcut(.defaultAction)
                            Button("Cancel", role: .cancel, action: {})
                                .keyboardShortcut(.cancelAction)
                        }
                        Spacer()
                    } else {
                        Button("Deselect All") {
                            selected.removeAll()
                        }
                        .buttonStyle(ConnectionsButtonStyle(fgColor: "textDark", bgColor: "edit"))
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        
                        Spacer()
                        Button(selected.count == 4 ? "GuessSelection" : "GuessTopRow") {
                            withAnimation {
                                let guessResult = selected.count == 4 ? game.guess(words: selected) : game.guess(row: 0..<4)
                                switch guessResult {
                                case .alreadyGuessed:
                                    Toast.alreadyGuessed()
                                case .oneAway:
                                    Toast.oneAway()
                                case .correct:
                                    selected.removeAll()
                                case .incorrect:
                                    break
                                }
                            }
                        }
                        .buttonStyle(ConnectionsButtonStyle(fgColor: "textDark", bgColor: "tasted"))
                        // always enables for the time being
                        .disabled(selected.count == 4 ? false : false)
                        Spacer()
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
            }

            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            VStack{
                if game.guesses.filter({$0.score != 4}).count > 0 {
                    GuessHistory(guesses: game.guesses)
                        .padding(EdgeInsets(top: 00, leading: 5, bottom: 20, trailing: 5))
                }
            }
            .frame(maxWidth: 500, maxHeight: 150)

            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    VStack{
                        Text(game.puzzleName!)
                    }
                    .foregroundColor(Color("textDark"))
                }
            }
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear{
            if game.guesses.filter({$0.score > 0}).count > 0 {
                gameInProgress.toggle()
            }
        }
        .sheet(isPresented: $gameInProgress) {
            GameInProgress(game: game)
                .padding()
        }

    }
}


struct GameViewPreview: View {
    
    @State var languageSettings = LanguageSetting()
    
    var locale: String

    var body: some View {
        
        let gameData = GameData(json: "{\"id\":151,\"puzzleName\":\"Unidad 6.1\",\"groups\":{\"DOCTORS’ ORDERS\":{\"level\":0,\"members\":[\"DIET\",\"EXERCISE\",\"FRESH AIR\",\"SLEEP\"]},\"EMAIL ACTIONS\":{\"level\":1,\"members\":[\"COMPOSE\",\"FORWARD\",\"REPLY ALL\",\"SEND\"]},\"PODCASTS\":{\"level\":2,\"members\":[\"RADIOLAB\",\"SERIAL\",\"UP FIRST\",\"WTF\"]},\"___ COMEDY\":{\"level\":3,\"members\":[\"BLACK\",\"DIVINE\",\"PROP\",\"SKETCH\"]}},\"startingGroups\":[[\"COMPOSE\",\"DIVINE\",\"EXERCISE\",\"SEND\"],[\"FRESH AIR\",\"FORWARD\",\"SERIAL\",\"SKETCH\"],[\"WTF\",\"PROP\",\"UP FIRST\",\"DIET\"],[\"BLACK\",\"RADIOLAB\",\"SLEEP\",\"REPLY ALL\"]]}")

        let game = Game(from: gameData, on: "2023-09-09")
        let _ = game.guess(words: Set(["DIET", "EXERCISE", "FRESH AIR", "SLEEP"]))
        let _ = game.guess(words: Set(["RADIOLAB", "UP FIRST", "WTF", "REPLY ALL"]))
//        let _ = game.guess(words: Set(["RADIOLAB", "UP FIRST", "WTF", "SERIAL"]))
//        let _ = game.guess(words: Set(["FORWARD", "COMPOSE", "REPLY ALL", "SEND"]))
//
        GameView(game: game)
            .environment(languageSettings)
            .environment(\.locale, Locale(identifier: locale))
    }
}

#Preview("EN"){
    GameViewPreview(locale: "EN")
}

#Preview("ES"){
    GameViewPreview(locale: "ES")
}

#Preview("Light"){
    GameViewPreview(locale: "EN")
        .preferredColorScheme(.light)
}

#Preview("Dark"){
    GameViewPreview(locale: "ES")
        .preferredColorScheme(.dark)
}
