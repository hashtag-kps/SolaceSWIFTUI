import SwiftUI
//geo
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
