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
            let localhost : String = ConnectionsApi.getIPAddress()

            return URL(string: "http://\(localhost):8000/WineGPSSupport/conexiones/puzzles/\(puzzleID).json")!
        } else {
            return URL(string: "https://adynak.github.io/conexiones/puzzles/\(puzzleID).json")
        }
    }
    
    static func getTOCUrl () -> URL? {
        if debugMode {
            let localhost : String = ConnectionsApi.getIPAddress()
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
    
    static func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
}
