import SwiftUI

struct ContentView: View {
    @Environment(GameModel.self) var gameModel

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "cup.and.saucer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundStyle(.tint)
            Text("Penn Dining\nScavenger Hunt!")
                .font(.title)
            
            NavigationLink(destination:  {
                DiningHallView()
            }) {
                Label("Begin", systemImage: "play")
                    .font(.headline)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } .onTapGesture {
                gameModel.beginGame()
            }
            .padding(40)
            Spacer()
            Text("note: you need to have your locations on for this game to work!")
                .font(.title3)
                .padding(30)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    @Previewable @State var gameModel = GameModel()
    
    ContentView()
        .environment(gameModel)
}
