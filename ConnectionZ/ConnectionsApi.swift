//
//  ConnectionsApi.swift
//  DraggableConnections
//
//  Created by Michael Goodnow on 11/10/23.
//

import Foundation

struct ConnectionsApi {
    static func fetchBy(date: String) async -> GameData? {
        let url = URL(string: "https://adynak.github.io/conexiones/puzzles/\(date).json")!
        //        let url = URL(string: "https://www.nytimes.com/svc/connections/v1/\(date).json")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(GameData.self, from:data)
        } catch {
            return nil
        }
    }
    
    static func fetchPuzzle(puzzleID: String) async -> GameData? {
        let url = URL(string: "https://adynak.github.io/conexiones/puzzles/\(puzzleID).json")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(GameData.self, from:data)
        } catch {
            return nil
        }
    }
    
    static func readTOC() async -> [Puzzles]? {
        let url = URL(string: "https://adynak.github.io/conexiones/puzzles/toc.json")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let jsonData = try? JSONDecoder().decode(ConnectionsTOC.self, from: data) {
                return jsonData.ConnectionsTOC
            }
        } catch {
            return nil
        }
        return nil
    }
    
}
