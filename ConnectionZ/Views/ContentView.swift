//
//  ContentView.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/9/23.
//

import SwiftUI
import SwiftData

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
    
    
    @SceneStorage("ContentView.selectedDate") private var selectedDate: String?
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Game.date) private var persistedGames: [Game]
    
    @State var refreshStyle: [Color] =  [Color("tabItemSelected"), Color("tabItemSelected")]
    @State var connectionsTOC: [Puzzles] = []
    
    
    private func downloadSelectedGame() async {
        if let date = selectedDate {
            if persistedGames.by(date: date) == nil  {
                print("Fetching puzzle \(date)")
                let response = await ConnectionsApi.fetchBy(date: date)
                if let gameData = response {
                    print("Inserting puzzle \(gameData.id) - \(date)")
                    print(gameData)
                    modelContext.insert(Game(from: gameData, on: date))
                    try? modelContext.save()
                }
            }
        }
    }
    
    //    var streakRepairDates: [Date] {
    //        guard let firstCompletedGame = persistedGames.first(where: \.isComplete) else {
    //            return []
    //        }
    //
    //        let firstDate = Date(iso8601: firstCompletedGame.date)
    //        var dates = [Date]()
    //        for date in DateSequence(startDate: Date().snapToDay()) {
    //            if (date <= firstDate) {
    //                break;
    //            }
    //            if let persistedGame = persistedGames.by(date: date.iso8601()) {
    //                if (persistedGame.isComplete) {
    //                    continue;
    //                }
    //            }
    //            dates.append(date)
    //        }
    //        return dates.reversed()
    //    }
    
    var body: some View {
        
        let archiveSectionTitle = NSLocalizedString("Archive",comment: "archive section title")
        
        NavigationSplitView {
            List(selection: $selectedDate) {
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
            .navigationTitle("Connections")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    VStack{
                        Text("Connections")
                    }
                    .foregroundColor(Color("textLight"))
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
//                        showLocationFilter.toggle()
//                        persistedGames.removeAll()
                    } label: {
                        ResizedImage(imageName: "clock.arrow.2.circlepath", size: 20, foregroundColor: Color("textLight"))
                    }
                }
                
            }
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbarBackground(
                Color("mainColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        } detail: {
            if let game = persistedGames.by(date: selectedDate) {
                GameView(game: game)
                    .navigationTitle(game.name)
#if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(false)
                    .toolbar {
                        ToolbarItemGroup(placement: .principal) {
                            VStack{
                                Text(game.name)
                            }
                            .foregroundColor(Color("textLight"))
                        }
                        //                        ToolbarItemGroup(placement: .topBarLeading) {
                        //                            Button {
                        //                                withAnimation(.easeInOut(duration: 2)) {
                        //                                    self.presentationMode.wrappedValue.dismiss()
                        //
                        //                                    dismiss()
                        //                                }
                        //                            } label: {
                        //                                ResizedImage(imageName: "chevron.left", size: 16)
                        //                            }
                        //                            .padding(.leading, 10)
                        //                        }
                    }
                    .toolbarColorScheme(.light, for: .navigationBar)
                    .toolbarBackground(
                        Color("mainColor"),
                        for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
#endif
            } else {
                Text("Select a game")
            }
        }
        .onChange(of: selectedDate, initial: true) {
            Task {
                await downloadSelectedGame()
            }
        }
        .onAppear{
            Task {
                connectionsTOC = await ConnectionsApi.readTOC() ?? []
            }
        }
    }
}

