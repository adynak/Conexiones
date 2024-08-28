//
//  CompletedGroups.swift
//  Conexiones
//
//  Created by al00p on 8/28/24.
//

import SwiftUI

struct CompletedGroups: View {
    let groups: [Group]
    var body: some View {
        ForEach(groups, id: \.name) { group in
            CompletedGroup(group: group)
        }
    }
}
