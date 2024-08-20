//
//  ConfigurableButtonStyle.swift
//  ConnectionZ
//
//  Created by al00p on 8/16/24.
//

import Foundation
import SwiftUI

struct ConnectionsButtonStyle: ButtonStyle {
    var fgColor: String
    var bgColor: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 150)
            .padding(8)
            .background(Color(bgColor))
            .foregroundColor(Color(fgColor))
            .cornerRadius(12)
    }
}
