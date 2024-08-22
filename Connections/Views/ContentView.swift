//
//  ContentView.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/9/23.
//

import SwiftUI
import SwiftData

@Observable
class LanguageSetting {
    // initialise this from UserDefaults if you like
    var locale = Locale(identifier: "es")
}

extension Array where Element: Game {
    func by(date dateMaybe: String?) -> Game? {
        guard let date = dateMaybe else {
            return nil
        }
        return first { $0.date == date }
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    @Environment(LanguageSetting.self) var languageSettings
    
    @SceneStorage("ContentView.selectedGame") private var selectedGame: String?
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Game.date) private var persistedGames: [Game]
    //    private var persistedGames: [Game] = []
    
    @State var refreshStyle: [Color] =  [Color("tabItemSelected"), Color("tabItemSelected")]
    @State var connectionsTOC: [Puzzles] = []
    
    @State var countryCode = "ES"
    
    
    private func downloadSelectedGame() async {
        if let date = selectedGame {
            if persistedGames.by(date: date) == nil  {
                print("Fetching puzzle \(date)")
                let response = await ConnectionsApi.fetchBy(date: date)
                if let gameData = response {
                    print("Inserting puzzle \(gameData.id) - \(date)")
//                    print(gameData)
                    modelContext.insert(Game(from: gameData, on: date))
                    try? modelContext.save()
                }
            }
        }
    }
    
    var body: some View {
        
        let archiveSectionTitle = NSLocalizedString("Archive",comment: "archive section title")
        
        NavigationSplitView {
            List(selection: $selectedGame) {
                //                Section(header: Text("Current")) {
                //                    NavigationLink("Today's Game", value: Date().iso8601())
                //                    NavigationLink("Yesterday's Game", value: Date().add(days: -1).iso8601())
                //                }
                //                GameGroupingView(sectionName: "In Progress", dates: persistedGames.filter(\.isInProgress).map(\.date), connectionsTOC: [])
                //                GameGroupingView(sectionName: "Streak Repair", dates: streakRepairDates.map { $0.iso8601() })
                //                GameGroupingView(sectionName: "Completed", dates: persistedGames.filter(\.isComplete).map(\.date).reversed(), connectionsTOC: [])
                GameGroupingView(
                    sectionName: archiveSectionTitle,
                    dates: Array(DateSequence(startDate: Date().snapToDay())).map { $0.iso8601() },
                    startCollapsed: false,
                    connectionsTOC: connectionsTOC
                )
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    VStack{
                        Text("Connections")
                            .font(.headline)
                        Text("Choose a Game")
                            .font(.footnote)
                    }
                    .foregroundColor(Color("textDarkLight"))
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Text(getFlag(from: countryCode))
                        .onTapGesture {
                            if countryCode == "ES" {
                                countryCode = "US"
                            } else {
                                countryCode = "ES"
                            }
                            languageSettings.locale = Locale(identifier: countryCode)
                        }
                }
            }
        } detail: {
            if let game = persistedGames.by(date: selectedGame) {
                GameView(game: game)
            } else {
                Text("Select a game")
            }
        }
        .onChange(of: selectedGame, initial: true) {
            Task {
                await downloadSelectedGame()
            }
        }
        .onAppear{
            Task {
                connectionsTOC = await ConnectionsApi.readTOC() ?? []
                let zz = "123"
//                let zz = connectionsTOC.puzzles.sorted(by: {$0.puzzleName < $1.puzzleName})
            }
        }
        
    }
    
    func getFlag(from countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
}

