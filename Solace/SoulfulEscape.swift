import SwiftUI

struct SoulfulEscape: View {
    @State private var searchText = ""
    @State private var selectedMood = "Sad"
    @State private var showingMenu = false
    @State private var likedTunes: Set<String> = []
    @State private var favoriteTunes: Set<String> = []  // New state for favorites
    @State private var isSearching = false
    let moods = ["Sad", "Uneasy", "Nervous", "Frustrated", "Hyper", "Furious"]
    @StateObject private var audioPlayer = AudioPlayerManager()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if isSearching {
                    // Search View
                    VStack(spacing: 16) {
                        // Search Header
                        HStack {
                            Button(action: {
                                isSearching = false
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 17))
                            }
                            Spacer()
                            Text("Search")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search for songs...", text: $searchText)
                                .font(.system(size: 17))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Search Results Grid
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(["Unlock Mind", "Innsomia Heal", "Restore Beats", "Cellular Healing", "Deep Sleep", "Inner Peace"], id: \.self) { item in
                                    VStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 160)
                                        
                                        Text(item)
                                            .font(.headline)
                                        Text(item == "Unlock Mind" ? "Clarity" :
                                             item == "Innsomia Heal" ? "Healing" :
                                             item == "Restore Beats" ? "Recovery" :
                                             item == "Cellular Healing" ? "Renewal" :
                                             item == "Deep Sleep" ? "Rest" : "Stress Relief")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .background(Color(.systemBackground))
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Search Bar Button
                            Button(action: {
                                isSearching = true
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    Text("Search for songs...")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                            
                            // Mood Selection
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(moods, id: \.self) { mood in
                                        Button(action: {
                                            selectedMood = mood
                                        }) {
                                            Text(mood)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedMood == mood ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                                .foregroundColor(selectedMood == mood ? .blue : .gray)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Mood Tunes Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Mood Tunes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(["Deep Sleep", "Insomnia Heal", "Deep Thinking"], id: \.self) { tune in
                                            VStack(alignment: .leading, spacing: 8) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.gray.opacity(0.2))
                                                        .frame(width: 160, height: 160)
                                                        .contextMenu {
                                                            Button(action: {}) {
                                                                Label("Add to playlist", systemImage: "plus")
                                                            }
                                                            
                                                            Button(action: {}) {
                                                                Label("Create New Playlist", systemImage: "music.note.list")
                                                            }
                                                        }
                                                    
                                                    // Add heart button in top-right corner
                                                    VStack {
                                                        HStack {
                                                            Spacer()
                                                            Button(action: {
                                                                if favoriteTunes.contains(tune) {
                                                                    favoriteTunes.remove(tune)
                                                                } else {
                                                                    favoriteTunes.insert(tune)
                                                                }
                                                            }) {
                                                                Image(systemName: favoriteTunes.contains(tune) ? "heart.fill" : "heart")
                                                                    .foregroundColor(.white)
                                                                    .padding(8)
                                                            }
                                                        }
                                                        Spacer()
                                                    }
                                                    .padding(8)
                                                    
                                                    // Play button at bottom-right
                                                    VStack {
                                                        Spacer()
                                                        HStack {
                                                            Spacer()
                                                            Button(action: {
                                                                if tune == "Deep Sleep" {
                                                                    audioPlayer.togglePlayback(songName: "DeepSleep")
                                                                }
                                                            }) {
                                                                Image(systemName: audioPlayer.isPlaying && tune == "Deep Sleep" ? "pause.fill" : "play.fill")
                                                                    .foregroundColor(.white)
                                                                    .padding(8)
                                                                    .background(Color.blue)
                                                                    .clipShape(Circle())
                                                            }
                                                        }
                                                    }
                                                    .padding(8)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(tune)
                                                        .font(.headline)
                                                    
                                                    HStack {
                                                        Text(tune == "Deep Sleep" ? "Restorative sleep" : 
                                                             tune == "Insomnia Heal" ? "Cellular healing" : "Calm creativity")
                                                            .foregroundColor(.gray)
                                                        Text("•")
                                                            .foregroundColor(.gray)
                                                        Text(tune == "Deep Sleep" ? "4 min" :
                                                             tune == "Insomnia Heal" ? "3 min" : "3 min")
                                                            .foregroundColor(.gray)
                                                    }
                                                    .font(.caption)
                                                    
                                                    if tune == "Deep Sleep" {
                                                        HStack {
                                                            Button(action: {
                                                                if likedTunes.contains("Deep Sleep") {
                                                                    likedTunes.remove("Deep Sleep")
                                                                } else {
                                                                    likedTunes.insert("Deep Sleep")
                                                                }
                                                            }) {
                                                                Image(systemName: likedTunes.contains("Deep Sleep") ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                                    .foregroundColor(.orange)
                                                            }
                                                            Text("72K")
                                                                .font(.caption)
                                                        }
                                                    } else if tune == "Insomnia Heal" {
                                                        HStack {
                                                            Button(action: {
                                                                if likedTunes.contains("Insomnia Heal") {
                                                                    likedTunes.remove("Insomnia Heal")
                                                                } else {
                                                                    likedTunes.insert("Insomnia Heal")
                                                                }
                                                            }) {
                                                                Image(systemName: likedTunes.contains("Insomnia Heal") ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                                    .foregroundColor(.orange)
                                                            }
                                                            Text("301K")
                                                                .font(.caption)
                                                        }
                                                    } else if tune == "Deep Thinking" {
                                                        HStack {
                                                            Button(action: {
                                                                if likedTunes.contains("Deep Thinking") {
                                                                    likedTunes.remove("Deep Thinking")
                                                                } else {
                                                                    likedTunes.insert("Deep Thinking")
                                                                }
                                                            }) {
                                                                Image(systemName: likedTunes.contains("Deep Thinking") ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                                    .foregroundColor(.orange)
                                                            }
                                                            Text("82K")
                                                                .font(.caption)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: 160)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Explore Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Explore")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    NavigationLink(destination: SongsListView()) {
                                        Text("See all")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        VStack(spacing: 16) {
                                            ForEach(["Radiant", "Elevated Spirit", "Joyful Calm"], id: \.self) { item in
                                                HStack(spacing: 16) {
                                                    // Image placeholder
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.gray.opacity(0.2))
                                                        .frame(width: 80, height: 80)
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(item)
                                                            .font(.headline)
                                                        Text(item == "Radiant" ? "Positivity" :
                                                             item == "Elevated Spirit" ? "Uplift" : "Focus")
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Button(action: {}) {
                                                        Image(systemName: "ellipsis")
                                                            .foregroundColor(.gray)
                                                            .padding(8)
                                                            .background(Color.gray.opacity(0.1))
                                                            .clipShape(Circle())
                                                    }
                                                    .contextMenu {
                                                        Button(action: {}) {
                                                            Label("Add to playlist", systemImage: "plus")
                                                        }
                                                        
                                                        Button(action: {}) {
                                                            Label("Create New Playlist", systemImage: "music.note.list")
                                                        }
                                                    }
                                                }
                                                .frame(width: 300)
                                                .padding()
                                                .background(Color(.systemBackground))
                                                .cornerRadius(16)
                                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            }
                                        }
                                        
                                        // Additional tunes column
                                        VStack(spacing: 16) {
                                            ForEach(["Harmonic Ease", "Slumber", "Inner Peace"], id: \.self) { item in
                                                HStack(spacing: 16) {
                                                    // Image placeholder
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.gray.opacity(0.2))
                                                        .frame(width: 80, height: 80)
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(item)
                                                            .font(.headline)
                                                        Text(item == "Harmonic Ease" ? "Ease" :
                                                             item == "Slumber" ? "Sleep" : "Calm")
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        showingMenu = true
                                                    }) {
                                                        Image(systemName: "ellipsis")
                                                            .foregroundColor(.gray)
                                                            .padding(8)
                                                            .background(Color.gray.opacity(0.1))
                                                            .clipShape(Circle())
                                                    }
                                                    .sheet(isPresented: $showingMenu) {
                                                        VStack(spacing: 0) {
                                                            Button(action: {
                                                                showingMenu = false
                                                            }) {
                                                                HStack {
                                                                    Text("Add to playlist")
                                                                        .foregroundColor(.black)
                                                                    Spacer()
                                                                    Image(systemName: "plus")
                                                                        .foregroundColor(.black)
                                                                }
                                                                .padding()
                                                            }
                                                            
                                                            Divider()
                                                            
                                                            Button(action: {
                                                                showingMenu = false
                                                            }) {
                                                                HStack {
                                                                    Text("Create New Playlist")
                                                                        .foregroundColor(.black)
                                                                    Spacer()
                                                                    Image(systemName: "music.note.list")
                                                                        .foregroundColor(.black)
                                                                }
                                                                .padding()
                                                            }
                                                        }
                                                        .background(.ultraThinMaterial)
                                                        .presentationDetents([.height(120)])
                                                        .presentationBackground(.ultraThinMaterial)
                                                    }
                                                    .popover(isPresented: $showingMenu) {
                                                        VStack(spacing: 0) {
                                                            Button(action: {
                                                                showingMenu = false
                                                            }) {
                                                                HStack {
                                                                    Text("Add to playlist")
                                                                        .foregroundColor(.black)
                                                                    Spacer()
                                                                    Image(systemName: "plus")
                                                                        .foregroundColor(.black)
                                                                }
                                                                .padding()
                                                            }
                                                            
                                                            Divider()
                                                            
                                                            Button(action: {
                                                                showingMenu = false
                                                            }) {
                                                                HStack {
                                                                    Text("Create New Playlist")
                                                                        .foregroundColor(.black)
                                                                    Spacer()
                                                                    Image(systemName: "music.note.list")
                                                                        .foregroundColor(.black)
                                                                }
                                                                .padding()
                                                            }
                                                        }
                                                        .background(Color(.systemBackground))
                                                        .frame(width: 250)
                                                        .cornerRadius(14)
                                                    }
                                                }
                                                .frame(width: 300)
                                                .padding()
                                                .background(Color(.systemBackground))
                                                .cornerRadius(16)
                                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Nature Tunes Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Nature Tunes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<4) { _ in
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 160, height: 160)
                                                .contextMenu {
                                                    Button(action: {}) {
                                                        Label("Add to playlist", systemImage: "plus")
                                                    }
                                                    
                                                    Button(action: {}) {
                                                        Label("Create New Playlist", systemImage: "music.note.list")
                                                    }
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                // Move MiniPlayerView here
                if (audioPlayer.isPlaying || audioPlayer.currentTime > 0) && !audioPlayer.showMediaPlayer {
                    MiniPlayerView(
                        audioPlayer: audioPlayer,
                        songName: "Deep Sleep",
                        songDescription: "Restorative sleep"
                    )
                    .onTapGesture {
                        audioPlayer.showMediaPlayer = true
                    }
                }
            }
            .padding(.bottom, 0)
        }
        .sheet(isPresented: $audioPlayer.showMediaPlayer) {
            MediaPlayerView(
                audioPlayer: audioPlayer,
                songName: "Deep Sleep",
                songDescription: "Restorative sleep",
                isLiked: Binding(
                    get: { favoriteTunes.contains("Deep Sleep") },
                    set: { newValue in
                        if newValue {
                            favoriteTunes.insert("Deep Sleep")
                        } else {
                            favoriteTunes.remove("Deep Sleep")
                        }
                    }
                ),
                isThumbsUp: Binding(
                    get: { likedTunes.contains("Deep Sleep") },
                    set: { newValue in
                        if newValue {
                            likedTunes.insert("Deep Sleep")
                        } else {
                            likedTunes.remove("Deep Sleep")
                        }
                    }
                )
            )
        }
    }
}

struct SoulfulEscape_Previews: PreviewProvider {
    static var previews: some View {
        SoulfulEscape()
    }
}

struct SongsListView: View {
    let songs = [
        (image: "radiant", title: "Radiant", subtitle: "Positivity"),
        (image: "harmonic_ease", title: "Harmonic Ease", subtitle: "Ease"),
        (image: "elevated_spirit", title: "Elevated Spirit", subtitle: "Uplift"),
        (image: "slumber", title: "Slumber", subtitle: "Sleep"),
        (image: "joyful_calm", title: "Joyful Calm", subtitle: "Focus")
    ]
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(songs, id: \.title) { song in
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 80, height: 80)
                            Image(song.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(song.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(song.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
            // Mini player bar placeholder (if needed)
        }
        .navigationTitle("Songs")
        .navigationBarTitleDisplayMode(.inline)
    }
}
