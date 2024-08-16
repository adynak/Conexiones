//
//  GameView.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/11/23.
//

import Foundation
import SwiftUI
import Drops

extension String: Identifiable {
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

struct CompletedGroup: View {
    let group: Group
    
    var color: Color {
        switch (group.level) {
        case 0: return Color(.displayP3, red: 245/256, green: 224/256, blue: 126/256)
        case 1: return Color(.displayP3, red: 167/256, green: 194/256, blue: 104/256)
        case 2: return Color(.displayP3, red: 180/256, green: 195/256, blue: 235/256)
        case 3: return Color(.displayP3, red: 178/256, green: 131/256, blue: 193/256)
        default: return Color.black
        }
    }
    
    var body: some View {
        VStack {
            Text(group.name).font(.title2).bold().foregroundStyle(.black)
            Text(group.words.sorted().joined(separator: ", ")).foregroundStyle(.black)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            RoundedRectangle(
                cornerSize: CGSize(
                    width: 10,
                    height: 10
                )
            ).fill(color))
    }
}

struct CompletedGroups: View {
    let groups: [Group]
    var body: some View {
        ForEach(groups, id: \.name) { group in
            CompletedGroup(group: group)
        }
    }
}

struct GameView: View {
    let cols = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    var game: Game
    @State var selected = Set<String>()
    @State var shouldShowConfirmationDialog = false;
    
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
    
    var guessButtonText: String {
        let guessSelection = NSLocalizedString("GuessSelection",comment: "button: guess selection")
        let guessTopRow = NSLocalizedString("GuessTopRow",comment: "button guess top row")
        
        return selected.count == 4 ? guessSelection : guessTopRow
    }
    
    var body: some View {
        VStack {
            GuessHistory(guesses: game.guesses)
            if game.isComplete {
                Text("Complete!").font(.title2)
            } else {
                Text("Create four groups of four!").font(.title2)
            }
            VStack(spacing: 8) {
                CompletedGroups(groups: game.foundGroups)
                LazyVGrid(columns: cols, spacing: 8, content: {
                    ReorderableForEach(items: game.words) { word in
                        Tile(word: word, selected: isSelected(word: word), selectAction: {
                            select(word: word)
                        })
                    } moveAction: { from, to in
                        game.words.move(fromOffsets: from, toOffset: to)
                    }
                })
            }
            .frame(minWidth: 300, maxWidth: 500, minHeight: 300, maxHeight: 500)
            .aspectRatio(1, contentMode: .fit)
            .layoutPriority(1)
            HStack {
                if game.isComplete {
                    Spacer()
                    Button("Reset Game") {
                        shouldShowConfirmationDialog = true
                    }.buttonStyle(.bordered)
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
                    Spacer()
                    Button("Deselect All") {
                        selected.removeAll()
                    }.buttonStyle(.bordered)
                    //                    Spacer()
                    //                    Button("Hoist") {
                    //                        withAnimation {
                    //                            game.hoist(words: selected)
                    //                        }
                    //                        withAnimation {
                    //                            selected.removeAll()
                    //                        }
                    //                    }.buttonStyle(.bordered)
                    Spacer()
                    Button(guessButtonText) {
                        withAnimation {
                            let guessResult =
                            selected.count == 4 ?
                            game.guess(words: selected) :
                            game.guess(row: 0..<4)
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
                    }.buttonStyle(.bordered)
                    Spacer()
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    let gameData = GameData(json: "{\"id\":151,\"groups\":{\"DOCTORS’ ORDERS\":{\"level\":0,\"members\":[\"DIET\",\"EXERCISE\",\"FRESH AIR\",\"SLEEP\"]},\"EMAIL ACTIONS\":{\"level\":1,\"members\":[\"COMPOSE\",\"FORWARD\",\"REPLY ALL\",\"SEND\"]},\"PODCASTS\":{\"level\":2,\"members\":[\"RADIOLAB\",\"SERIAL\",\"UP FIRST\",\"WTF\"]},\"___ COMEDY\":{\"level\":3,\"members\":[\"BLACK\",\"DIVINE\",\"PROP\",\"SKETCH\"]}},\"startingGroups\":[[\"COMPOSE\",\"DIVINE\",\"EXERCISE\",\"SEND\"],[\"FRESH AIR\",\"FORWARD\",\"SERIAL\",\"SKETCH\"],[\"WTF\",\"PROP\",\"UP FIRST\",\"DIET\"],[\"BLACK\",\"RADIOLAB\",\"SLEEP\",\"REPLY ALL\"]]}")
    let game = Game(from: gameData, on: "2023-09-09")
      game.guess(words: Set(["RADIOLAB", "UP FIRST", "WTF", "FORWARD"]))
      game.guess(words: Set(["RADIOLAB", "UP FIRST", "WTF", "REPLY ALL"]))
      game.guess(words: Set(["RADIOLAB", "UP FIRST", "WTF", "SERIAL"]))
      game.guess(words: Set(["FORWARD", "COMPOSE", "REPLY ALL", "SEND"]))
//      game.guess(words: Set(["DIVINE", "PROP", "BLACK", "SKETCH"]))
//      game.guess(words: Set(["EXERCISE", "FRESH AIR", "DIET", "SLEEP"]))
    return GameView(game: game)
//        .frame(width: 300, height: 600)
}
