import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ExploreView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Soulful Escapes")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "aqi.medium")
                    Text("Peace Points")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
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

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
        }
    }
}

#Preview {
    ContentView()
}
