import SwiftUI

struct MediaPlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayerManager
    let songName: String
    let songDescription: String
    let thumbsUp: String
    @Binding var isLiked: Bool
    @Binding var isThumbsUp: Bool
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    @State private var isMinimized = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Image and Title Section
                VStack(spacing: 16) {
                    // Song Image
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 300, height: 300)
                    
                    // Song Info
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(songName)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button(action: {
                                isLiked.toggle()
                            }) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(isLiked ? .red : .gray)
                            }
                            Button(action: {
                                isThumbsUp.toggle()
                            }) {
                                HStack {
                                    Image(systemName: isThumbsUp ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .foregroundColor(isThumbsUp ? .orange : .gray)
                                    Text(thumbsUp)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.trailing, 32)
                        HStack(spacing: 4) {
                            Text(songDescription)
                                .foregroundColor(.gray)
                            Text("•")
                                .foregroundColor(.gray)
                            Text(timeString(from: audioPlayer.duration))
                                .foregroundColor(.gray)
                        }
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 32)
                }
                .padding(.top, 40)
                
                // Progress Bar
                VStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { audioPlayer.currentTime },
                            set: { audioPlayer.seek(to: $0) }
                        ),
                        in: 0...audioPlayer.duration
                    )
                    .accentColor(.blue)
                    
                    HStack {
                        Text(timeString(from: audioPlayer.currentTime))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(timeString(from: audioPlayer.duration))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Control Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        audioPlayer.toggleShuffle()
                    }) {
                        Image(systemName: "shuffle")
                            .font(.title2)
                            .foregroundColor(audioPlayer.isShuffle ? .blue : .gray)
                    }
                    
                    Button(action: {
                        audioPlayer.previous()
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        audioPlayer.togglePlayback()
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        audioPlayer.next()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        audioPlayer.toggleRepeat()
                    }) {
                        Image(systemName: "repeat")
                            .font(.title2)
                            .foregroundColor(audioPlayer.isRepeat ? .blue : .gray)
                    }
                }
                .padding(.vertical, 30)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            if !audioPlayer.showMediaPlayer {
                VStack {
                    Spacer()
                    MiniPlayerView(
                        audioPlayer: audioPlayer,
                        songName: songName,
                        songDescription: songDescription
                    )
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

struct MiniPlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayerManager
    let songName: String
    let songDescription: String
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2))
            
            HStack(spacing: 16) {
                // Song Image
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Image("Deep Sleep")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Song Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(songName)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(1)
                    Text(songDescription)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 24) {
                    // Previous Track Button
                    Button(action: {
                        audioPlayer.previous()
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                    
                    // Play/Pause Button
                    Button(action: {
                        audioPlayer.togglePlayback()
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    
                    // Next Track Button
                    Button(action: {
                        audioPlayer.next()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Progress Bar
            GeometryReader { geometry in
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * CGFloat(audioPlayer.currentTime / audioPlayer.duration))
            }
            .frame(height: 2)
        }
        .background(Color(.systemBackground))
    }
}
