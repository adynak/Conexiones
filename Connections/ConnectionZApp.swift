//
//  DraggableConnectionsApp.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/9/23.
//

import SwiftUI
import SwiftData

let debugMode = Bundle.main.infoDictionary?["debugMode"] as! Bool
//let localhost = Bundle.main.infoDictionary?["localhost"] as! String

private func createModelContainer() -> ModelContainer {
    let schema = Schema([Game.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}

@main
struct ConnectionZApp: App {
    
    @State var languageSettings = LanguageSetting()

    let sharedModelContainer: ModelContainer
        
    init() {
        self.sharedModelContainer = createModelContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(languageSettings)
                .environment(\.locale, languageSettings.locale)
        }
        .modelContainer(sharedModelContainer)
    }
}
