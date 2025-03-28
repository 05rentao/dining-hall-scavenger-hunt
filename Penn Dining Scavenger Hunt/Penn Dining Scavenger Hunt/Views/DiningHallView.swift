//
//  DiningHallView.swift
//  Penn Dining Scavenger Hunt
//
//  Created by user268994 on 3/24/25.
//

import SwiftUI

struct DiningHallView: View {
    @Environment(GameModel.self) var gameModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            List {
                Section("🍽️ Collected Halls") {
                    ForEach(gameModel.collectedHalls) { diningHall in
                        NavigationLink(value: diningHall) {
                            Label(diningHall.name, systemImage: "checkmark.circle.fill")
                                .font(.title3)
                        }
                    }
                }
                
                Section("📍 Uncollected Halls") {
                    ForEach(gameModel.uncollectedHalls) { diningHall in
                        NavigationLink(value: diningHall) {
                            Label(diningHall.name, systemImage: "fork.knife.circle")
                                .font(.title3)
                                .onTapGesture {
                                    gameModel.currentDiningHall = diningHall
                                    gameModel.state = .collect
                                }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .headerProminence(.increased)
            .navigationTitle("Gotta collect em' all!")
            Spacer()
        }
        .onAppear() {
            gameModel.state = GameState.running
        }
    }
}

#Preview {
    @Previewable @State var gameModel = GameModel()
    
    DiningHallView()
        .environment(gameModel)
}
