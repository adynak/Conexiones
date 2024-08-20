//
//  Toast.swift
//  ConnectionZ
//
//  Created by Michael Goodnow on 2/25/24.
//

import Foundation
import SwiftUI
import Drops

struct Toast {
    static func copied() -> Void {
#if os(iOS)
        Drops.show(
            Drop(
                title:"Copied!", icon: UIImage(systemName: "paperclip")
            )
        )
#endif
    }
    
    static func alreadyGuessed() -> Void {
#if os(iOS)
        let alreadyGuessed = NSLocalizedString("AlreadyGuessed",comment: "already guessed toast")
        Drops.show(
            Drop(
                title: alreadyGuessed, icon: UIImage(systemName:"repeat")
            )
        )
#endif
    }
    
    static func oneAway() -> Void {
#if os(iOS)
        let oneAway = NSLocalizedString("OneAway",comment: "one away toast")
        Drops.show(
            Drop(
                title: oneAway, icon: UIImage(systemName: "3.square")
            )
        )
#endif
    }
}
