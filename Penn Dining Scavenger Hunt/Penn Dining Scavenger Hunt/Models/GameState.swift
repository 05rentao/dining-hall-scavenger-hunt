//
//  GameState.swift
//  Penn Dining Scavenger Hunt
//
//  Created by user268994 on 3/25/25.
//

import Foundation
import SwiftUI

enum GameState : Equatable {
    // when you have just booted up the game
    case notRunning
    
    // when the game is running, no collection requests are made
    case running
    
    // when there is some sort of error such as getting location
    case error
    
    // when the player is in the collection screen and can collect that dining hall
    case collect
    
}
