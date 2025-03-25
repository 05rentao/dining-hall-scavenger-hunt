//
//  Penn_Dining_Scavenger_HuntApp.swift
//  Penn Dining Scavenger Hunt
//
//  Created by user268994 on 3/24/25.
//

import SwiftUI

@main
struct Penn_Dining_Scavenger_HuntApp: App {
    @State var gameModel = GameModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gameModel)
        }
    }
}
