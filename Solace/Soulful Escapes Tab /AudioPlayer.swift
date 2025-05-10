import SwiftUI
import AVFoundation
import Combine

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var isFavorite = false
    @Published var showMediaPlayer = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    private var timer: Timer?
    
    // Playlist and controls
    @Published var playlist: [SoulfulEscapeSong] = []
    @Published var currentIndex: Int = 0
    @Published var isShuffle: Bool = false
    @Published var isRepeat: Bool = false
    @Published var currentSong: SoulfulEscapeSong? = nil
    
    func setPlaylist(_ songs: [SoulfulEscapeSong]) {
        playlist = songs
        if !songs.isEmpty {
            currentIndex = 0
            currentSong = songs[0]
        }
    }
    
    func play(song: SoulfulEscapeSong) {
        audioPlayer?.stop() // Stop any current playback
        if let idx = playlist.firstIndex(where: { $0.id == song.id }) {
            currentIndex = idx
            currentSong = song
        }
        guard let path = Bundle.main.path(forResource: song.fileUrl, ofType: "mp3") else {
            print("Could not find \(song.fileUrl).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            duration = audioPlayer?.duration ?? 0
            startTimer()
            showMediaPlayer = true  // Only set to true when starting playback
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        stopTimer()
    }
    
    func togglePlayback() {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
            timer?.invalidate()
            timer = nil
        } else {
            audioPlayer?.play()
            isPlaying = true
            startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.audioPlayer?.currentTime ?? 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        currentTime = 0
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func playCurrent() {
        guard !playlist.isEmpty else { return }
        let song = playlist[currentIndex]
        play(song: song)
    }
    
    func next() {
        guard !playlist.isEmpty else { return }
        if isShuffle {
            var newIndex: Int
            repeat {
                newIndex = Int.random(in: 0..<playlist.count)
            } while playlist.count > 1 && newIndex == currentIndex
            currentIndex = newIndex
        } else {
            currentIndex = (currentIndex + 1) % playlist.count
        }
        playCurrent()
    }
    
    func previous() {
        guard !playlist.isEmpty else { return }
        if isShuffle {
            currentIndex = Int.random(in: 0..<playlist.count)
        } else {
            currentIndex = (currentIndex - 1 + playlist.count) % playlist.count
        }
        playCurrent()
    }
    
    func toggleShuffle() {
        isShuffle.toggle()
    }
    
    func toggleRepeat() {
        isRepeat.toggle()
    }
    
    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Song finished, moving to next (repeat: \(isRepeat))")
        if isRepeat {
            playCurrent()
        } else {
            next()
        }
    }
}