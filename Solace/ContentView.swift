import SwiftUI 

struct ContentView: View { 
    init() {} // Add explicit initializer
    
    var body: some View { 
        TabView { 
            MoodTrackerAppView() 
                .tabItem { 
                    Image(systemName: "house.fill") 
                    Text("Home") 
                } 
            
            SoulfulEscape() 
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

