import SwiftUI

let moodSongs: [String: [SoulfulEscapeSong]] = [
    "default": [
        SoulfulEscapeSong(id: UUID(), imageName: "deepsleep", title: "Deep Sleep", subtitle: "Restful night", duration: 300, category: .neutral, likeCount: 200, fileUrl: "DeepSleep", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "deepthinking", title: "Deep Thinking", subtitle: "Focus your mind", duration: 320, category: .neutral, likeCount: 180, fileUrl: "DeepThinking", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "default3", title: "Gentle Stream", subtitle: "Calm waters", duration: 250, category: .neutral, likeCount: 150, fileUrl: "gentle_stream", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "default4", title: "Evening Calm", subtitle: "Relax and unwind", duration: 270, category: .neutral, likeCount: 160, fileUrl: "evening_calm", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "default5", title: "Morning Light", subtitle: "Start fresh", duration: 230, category: .neutral, likeCount: 140, fileUrl: "morning_light", createdAt: Date())
    ],
    "Very Pleasant": [
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant1", title: "Sunrise Joy", subtitle: "Start your day happy", duration: 180, category: .veryPleasant, likeCount: 120, fileUrl: "InnsomiaHeal", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant2", title: "Blissful Breeze", subtitle: "Feel the breeze", duration: 200, category: .veryPleasant, likeCount: 98, fileUrl: "blissful_breeze", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant3", title: "Radiant Smile", subtitle: "Keep smiling", duration: 210, category: .veryPleasant, likeCount: 110, fileUrl: "radiant_smile", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant4", title: "Cheerful Steps", subtitle: "Walk with joy", duration: 190, category: .veryPleasant, likeCount: 105, fileUrl: "cheerful_steps", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant5", title: "Uplifted", subtitle: "Feel uplifted", duration: 175, category: .veryPleasant, likeCount: 99, fileUrl: "uplifted", createdAt: Date())
    ],
    "Pleasant": [
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant1", title: "Gentle Morning", subtitle: "Soft start", duration: 185, category: .pleasant, likeCount: 90, fileUrl: "DeepSleep", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant2", title: "Calm Waters", subtitle: "Peaceful flow", duration: 195, category: .pleasant, likeCount: 87, fileUrl: "calm_waters", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant3", title: "Bright Path", subtitle: "Walk bright", duration: 205, category: .pleasant, likeCount: 92, fileUrl: "bright_path", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant4", title: "Serene Fields", subtitle: "Green and calm", duration: 180, category: .pleasant, likeCount: 88, fileUrl: "serene_fields", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "pleasant5", title: "Joyful Tune", subtitle: "Feel the joy", duration: 170, category: .pleasant, likeCount: 85, fileUrl: "joyful_tune", createdAt: Date())
    ],
    "Neutral": [
        SoulfulEscapeSong(id: UUID(), imageName: "neutral1", title: "Balanced Mind", subtitle: "Stay centered", duration: 200, category: .neutral, likeCount: 80, fileUrl: "DeepThinking", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "neutral2", title: "Steady Flow", subtitle: "Go with the flow", duration: 210, category: .neutral, likeCount: 75, fileUrl: "steady_flow", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "neutral3", title: "Middle Ground", subtitle: "Find your center", duration: 190, category: .neutral, likeCount: 78, fileUrl: "middle_ground", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "neutral4", title: "Calm Pause", subtitle: "Take a break", duration: 185, category: .neutral, likeCount: 82, fileUrl: "calm_pause", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "neutral5", title: "Evening Ease", subtitle: "Relax your mind", duration: 175, category: .neutral, likeCount: 77, fileUrl: "evening_ease", createdAt: Date())
    ],
    "Unpleasant": [
        SoulfulEscapeSong(id: UUID(), imageName: "unpleasant1", title: "Soothing Rain", subtitle: "Let it wash away", duration: 210, category: .unpleasant, likeCount: 60, fileUrl: "InnsomiaHeal", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "unpleasant2", title: "Gentle Comfort", subtitle: "Find comfort", duration: 200, category: .unpleasant, likeCount: 65, fileUrl: "gentle_comfort", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "unpleasant3", title: "Quiet Night", subtitle: "Rest easy", duration: 220, category: .unpleasant, likeCount: 62, fileUrl: "quiet_night", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "unpleasant4", title: "Soft Embrace", subtitle: "Feel held", duration: 205, category: .unpleasant, likeCount: 68, fileUrl: "soft_embrace", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "unpleasant5", title: "Gentle Hope", subtitle: "Hope returns", duration: 195, category: .unpleasant, likeCount: 63, fileUrl: "gentle_hope", createdAt: Date())
    ],
    "Very Unpleasant": [
        SoulfulEscapeSong(id: UUID(), imageName: "veryunpleasant1", title: "Healing Light", subtitle: "Find the light", duration: 215, category: .veryUnpleasant, likeCount: 50, fileUrl: "DeepSleep", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "veryunpleasant2", title: "Warm Blanket", subtitle: "Feel safe", duration: 205, category: .veryUnpleasant, likeCount: 52, fileUrl: "warm_blanket", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "veryunpleasant3", title: "Gentle Whisper", subtitle: "Soft words", duration: 210, category: .veryUnpleasant, likeCount: 48, fileUrl: "gentle_whisper", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "veryunpleasant4", title: "Quiet Strength", subtitle: "You are strong", duration: 200, category: .veryUnpleasant, likeCount: 55, fileUrl: "quiet_strength", createdAt: Date()),
        SoulfulEscapeSong(id: UUID(), imageName: "veryunpleasant5", title: "New Dawn", subtitle: "A new start", duration: 190, category: .veryUnpleasant, likeCount: 53, fileUrl: "new_dawn", createdAt: Date())
    ]
]

struct Song: Equatable {
    let name: String
    let description: String
    let thumbsUp: String
}

struct SoulfulEscape: View {
    @State private var searchText = ""
    @State private var selectedMood = "Sad"
    @State private var showingMenu = false
    @State private var likedTunes: Set<UUID> = Set(UserDefaults.standard.stringArray(forKey: "likedTunes")?.compactMap { UUID(uuidString: $0) } ?? [])
    @State private var favoriteTunes: Set<UUID> = Set(UserDefaults.standard.stringArray(forKey: "favoriteTunes")?.compactMap { UUID(uuidString: $0) } ?? [])
    @State private var isSearching = false
    let moods = ["Sad", "Uneasy", "Nervous", "Frustrated", "Hyper", "Furious"]
    @StateObject private var audioPlayer = AudioPlayerManager()
    @State private var currentSong: SoulfulEscapeSong? = nil
    @StateObject var dataController = AppDataController.sharedAppDataController
    
    private func saveLikesAndFavorites() {
        UserDefaults.standard.set(Array(likedTunes).map { $0.uuidString }, forKey: "likedTunes")
        UserDefaults.standard.set(Array(favoriteTunes).map { $0.uuidString }, forKey: "favoriteTunes")
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if isSearching {
                    SearchPanel(
                        searchText: $searchText,
                        selectedMood: $selectedMood,
                        moods: moods,
                        isSearching: $isSearching
                    )
                } else {
                    MainPanel(
                        searchText: $searchText,
                        selectedMood: $selectedMood,
                        moods: moods,
                        likedTunes: $likedTunes,
                        favoriteTunes: $favoriteTunes,
                        showingMenu: $showingMenu,
                        audioPlayer: audioPlayer,
                        currentSong: $currentSong,
                        dataController: dataController
                    )
                }
                // Move MiniPlayerView here
                if let song = currentSong, (audioPlayer.isPlaying || audioPlayer.currentTime > 0) && !audioPlayer.showMediaPlayer {
                    MiniPlayerView(
                        audioPlayer: audioPlayer,
                        songName: song.title,
                        songDescription: song.subtitle
                    )
                    .onTapGesture {
                        audioPlayer.showMediaPlayer = true
                    }
                }
            }
            .padding(.bottom, 0)
            .onChange(of: audioPlayer.currentIndex) { newIndex in
                if audioPlayer.playlist.indices.contains(newIndex) {
                    currentSong = audioPlayer.playlist[newIndex]
                }
            }
        }
        .sheet(isPresented: $audioPlayer.showMediaPlayer) {
            if let song = currentSong {
                MediaPlayerView(
                    audioPlayer: audioPlayer,
                    songName: song.title,
                    songDescription: song.subtitle,
                    thumbsUp: String(song.likeCount),
                    isLiked: Binding(
                        get: {
                            print("[MediaPlayerView] Checking favorite for song id: \(song.id)")
                            return favoriteTunes.contains(song.id)
                        },
                        set: { newValue in
                            print("[MediaPlayerView] Setting favorite for song id: \(song.id) to \(newValue)")
                            if newValue {
                                favoriteTunes.insert(song.id)
                            } else {
                                favoriteTunes.remove(song.id)
                            }
                            saveLikesAndFavorites()
                        }
                    ),
                    isThumbsUp: Binding(
                        get: {
                            print("[MediaPlayerView] Checking liked for song id: \(song.id)")
                            return likedTunes.contains(song.id)
                        },
                        set: { newValue in
                            print("[MediaPlayerView] Setting liked for song id: \(song.id) to \(newValue)")
                            if newValue {
                                likedTunes.insert(song.id)
                            } else {
                                likedTunes.remove(song.id)
                            }
                            saveLikesAndFavorites()
                        }
                    )
                )
            }
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

struct MoodTunesSection: View {
    @ObservedObject var dataController: AppDataController
    @Binding var likedTunes: Set<UUID>
    @Binding var favoriteTunes: Set<UUID>
    @ObservedObject var audioPlayer: AudioPlayerManager
    @Binding var currentSong: SoulfulEscapeSong?
    let songs: [SoulfulEscapeSong]
    
    private func saveLikesAndFavorites() {
        UserDefaults.standard.set(Array(likedTunes).map { $0.uuidString }, forKey: "likedTunes")
        UserDefaults.standard.set(Array(favoriteTunes).map { $0.uuidString }, forKey: "favoriteTunes")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Tunes")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(songs) { song in
                        SongCardView(
                            song: song,
                            isLiked: likedTunes.contains(song.id),
                            isFavorite: favoriteTunes.contains(song.id),
                            onLike: {
                                if likedTunes.contains(song.id) {
                                    likedTunes.remove(song.id)
                                } else {
                                    likedTunes.insert(song.id)
                                }
                                saveLikesAndFavorites()
                            },
                            onFavorite: {
                                if favoriteTunes.contains(song.id) {
                                    favoriteTunes.remove(song.id)
                                } else {
                                    favoriteTunes.insert(song.id)
                                }
                                saveLikesAndFavorites()
                            },
                            onPlay: {
                                audioPlayer.setPlaylist(songs)
                                currentSong = song
                                audioPlayer.play(song: song)
                            },
                            isPlaying: audioPlayer.isPlaying && currentSong?.id == song.id
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SongCardView: View {
    let song: SoulfulEscapeSong
    let isLiked: Bool
    let isFavorite: Bool
    let onLike: () -> Void
    let onFavorite: () -> Void
    let onPlay: () -> Void
    let isPlaying: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 160)
                VStack {
                    HStack {
                        Spacer()
                        Button(action: onFavorite) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                                .padding(8)
                        }
                    }
                    Spacer()
                }
                .padding(8)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: onPlay) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(8)
            }
            .onTapGesture(perform: onPlay)
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                HStack {
                    Text(song.subtitle)
                        .foregroundColor(.gray)
                    Text("•")
                        .foregroundColor(.gray)
                    Text("\(Int(song.duration/60)) min")
                        .foregroundColor(.gray)
                }
                .font(.caption)
                HStack {
                    Button(action: onLike) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(isLiked ? .orange : .gray)
                    }
                    Text("\(song.likeCount)K")
                        .font(.caption)
                }
            }
        }
        .frame(width: 160)
    }
}

struct ExploreSection: View {
    @Binding var showingMenu: Bool
    var body: some View {
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
                                    Button(action: {
                                        // Add to playlist action
                                    }) {
                                        Label("Add to playlist", systemImage: "plus")
                                    }
                                    Button(action: {
                                        // Create new playlist action
                                    }) {
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
                    VStack(spacing: 16) {
                        ForEach(["Harmonic Ease", "Slumber", "Inner Peace"], id: \.self) { item in
                            HStack(spacing: 16) {
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
                                .contextMenu {
                                    Button(action: {
                                        // Add to playlist action
                                    }) {
                                        Label("Add to playlist", systemImage: "plus")
                                    }
                                    Button(action: {
                                        // Create new playlist action
                                    }) {
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
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NatureTunesSection: View {
    var body: some View {
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
}

// MARK: - Subviews

struct SearchPanel: View {
    @Binding var searchText: String
    @Binding var selectedMood: String
    let moods: [String]
    @Binding var isSearching: Bool
    var body: some View {
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
            // Search Bar with Mood Switch
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for songs...", text: $searchText)
                    .font(.system(size: 20))
                    .padding(.vertical, 18)
            }
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .cornerRadius(16)
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
    }
}

struct MainPanel: View {
    @Binding var searchText: String
    @Binding var selectedMood: String
    let moods: [String]
    @Binding var likedTunes: Set<UUID>
    @Binding var favoriteTunes: Set<UUID>
    @Binding var showingMenu: Bool
    var audioPlayer: AudioPlayerManager
    @Binding var currentSong: SoulfulEscapeSong?
    @ObservedObject var dataController: AppDataController
    @State private var showTunesByMood = false
    @State private var lastLoggedMood: MoodCategory? = nil
    
    private func saveLikesAndFavorites() {
        UserDefaults.standard.set(Array(likedTunes).map { $0.uuidString }, forKey: "likedTunes")
        UserDefaults.standard.set(Array(favoriteTunes).map { $0.uuidString }, forKey: "favoriteTunes")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Toggle for mood-based tunes
                Toggle("Show tunes by mood", isOn: $showTunesByMood)
                    .padding(.horizontal)
                // Search Bar Button with Mood Switch
                HStack {
                    Button(action: {
                        // This should trigger search mode in parent
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search for songs...")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                                .padding(.vertical, 18)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                // Mood Tunes Section
                let moodKey: String = showTunesByMood ? (dataController.lastLoggedMoodString ?? "Neutral") : "default"
                let filteredSongs: [SoulfulEscapeSong] = moodSongs[moodKey] ?? moodSongs["default"]!
                MoodTunesSection(
                    dataController: dataController,
                    likedTunes: $likedTunes,
                    favoriteTunes: $favoriteTunes,
                    audioPlayer: audioPlayer,
                    currentSong: $currentSong,
                    songs: filteredSongs
                )
                // Explore Section
                ExploreSection(showingMenu: $showingMenu)
                // Nature Tunes Section
                NatureTunesSection()
            }
            .padding(.vertical)
        }
    }
}
