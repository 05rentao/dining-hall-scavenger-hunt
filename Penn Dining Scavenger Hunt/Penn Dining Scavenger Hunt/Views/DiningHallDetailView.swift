//
//  DiningHallDetailView.swift
//  Penn Dining Scavenger Hunt
//
//  Created by user268994 on 3/24/25.
//

import SwiftUI 

struct DiningHallDetailView: View {
    @Environment(GameModel.self) var gameModel
    let diningHall: DiningHall
    
    private func collectingMode() {
        gameModel.currentDiningHall = diningHall
        if gameModel.withinRange(diningHall: diningHall) {
            gameModel.state = .collect
        }
    }
    private func resetCollection() {
        gameModel.currentDiningHall = nil
        gameModel.state = .running
    }
    
    var body: some View {
        VStack() {
            Spacer()
            Image(systemName: "fork.knife")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.tint)
            
            Text(diningHall.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(10)
            Text("Status:")
                .font(.title2)
            if gameModel.isCollected(dhall: diningHall) {
                Text("collected ✅")
                    .font(.title2)
                    .fontWeight(.bold)
            } else {
                Text("to be collected...")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Button("collect") {
                gameModel.collect(diningHall: diningHall)
            }
                .font(.headline)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            if gameModel.withinRange(diningHall: diningHall) {
                Text("Collection possible, within 50 feet")
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            } else {
                Text("Collection not possible: too far away")
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
            Text("Tip: \n To collect the dining hall, walk  within 50 meters of \(diningHall.name) and shake your phone!")
                .font(.title3)
                .padding(40)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
        .navigationTitle(diningHall.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: collectingMode)
        .onDisappear(perform: resetCollection)

    }
}

#Preview {
    @Previewable @State var gameModel = GameModel()
    
    DiningHallDetailView(diningHall: DiningHall.diningHalls[0])
        .environment(gameModel)
}

