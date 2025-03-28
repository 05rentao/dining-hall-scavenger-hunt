import SwiftUI

struct ContentView: View {
    @Environment(GameModel.self) var gameModel
    @State var locPromptVisible = false

    var body: some View {
        NavigationStack {
            VStack {
                switch gameModel.state {
                case .notRunning:
                    
                    Spacer()
                    Image(systemName: "cup.and.saucer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.tint)
                    Text("Penn Dining\nScavenger Hunt!")
                        .font(.title)
                    
                    Button("start") {
                        locPromptVisible = true
                    }
                    .font(.headline)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    .padding(40)
                    Spacer()
                    Text("note: you need to have your locations on for this game to work!")
                        .font(.title3)
                        .padding(30)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                case .error:
                    ErrorView()
                default:
                    DiningHallView()
                }
            }
            .navigationDestination(for:DiningHall.self) { diningHall in
                DiningHallDetailView(diningHall: diningHall)
            }
            .sheet(isPresented: $locPromptVisible) {
                VStack {
                    Text("In order to play, Penn Dining Scavenger Hunt needs to access your location to determine whether you are in the vincinity of a dining hall.")
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.title)
                                Button("OK") {
                                    locPromptVisible = false
                                    gameModel.state = .running
                                    gameModel.beginGame()
                                }
                                
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var gameModel = GameModel()
    
    ContentView()
        .environment(gameModel)
}
