//
//  CompletedGroup.swift
//  Conexiones
//
//  Created by al00p on 8/28/24.
//

import SwiftUI

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
            Text(group.name)
                .font(.callout)
                .bold()
                .foregroundStyle(.black)
            Text(group.words.sorted().joined(separator: ", "))
                .font(.footnote)
                .foregroundStyle(.black)
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


struct CompletedGroupPreview: View {
    var body: some View {
        let group = Group(name: "Group Name", level: 1, words: ["word1", "word2", "word3", "word4"])
        CompletedGroup(group: group)

    }
}

#Preview {
    CompletedGroupPreview()
}
