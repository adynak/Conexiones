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

struct CompletedGroupsPreview: View {
    var body: some View {
        let group = [
            Group(name: "Group Name", level: 1, words: ["word11", "word12", "word13", "word14"]),
            Group(name: "Group Name2", level: 2, words: ["word21", "word22", "word23", "word24"])
        ]
        CompletedGroups(groups: group)
    }
}


#Preview(){
    CompletedGroupsPreview()
}
