import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MoodTrackerAppView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ExploreView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Soulful Escapes")
                }
            
            PeacePointView()
                .tabItem {
                    Image(systemName: "aqi.medium")
                    Text("Peace Points")
                }
        }
    }
}



struct ExploreView: View {
    var body: some View {
        VStack {
            Text("Explore")
        }
    }
}



#Preview {
    ContentView()
}
