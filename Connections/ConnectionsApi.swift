//
//  ConnectionsApi.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/10/23.
//

import Foundation

struct ConnectionsApi {
    static func fetchBy(date: String) async -> GameData? {
        let url = getPuzzleUrl(puzzleID: date)!
        //        let url = URL(string: "https://www.nytimes.com/svc/connections/v1/\(date).json")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(GameData.self, from:data)
        } catch {
            return nil
        }
    }
    
    static func fetchPuzzle(puzzleID: String) async -> GameData? {
        let url = getPuzzleUrl(puzzleID: puzzleID)!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(GameData.self, from:data)
        } catch {
            return nil
        }
    }
    
    static func getPuzzleUrl (puzzleID: String) -> URL? {
        if debugMode {
            return URL(string: "http://\(localhost):8000/WineGPSSupport/conexiones/puzzles/\(puzzleID).json")!
        } else {
            return URL(string: "https://adynak.github.io/conexiones/puzzles/\(puzzleID).json")
        }
    }
    
    static func getTOCUrl () -> URL? {
        if debugMode {
            return URL(string: "http://\(localhost):8000/WineGPSSupport/conexiones/puzzles/toc.json")!
        } else {
            return URL(string: "https://adynak.github.io/conexiones/puzzles/toc.json")
        }
    }
    
    static func readTOC() async -> [Puzzles]? {
        let url = getTOCUrl()!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let jsonData = try? JSONDecoder().decode(ConnectionsTOC.self, from: data) {
                
//                let sortedArray = jsonData.sorted { $0["puzzleName"]! < $1["puzzleName"]! }

                return jsonData.ConnectionsTOC
            }
        } catch {
            return nil
        }
        return nil
    }
    
}
