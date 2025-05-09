import SwiftUI
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var isFavorite = false
    @Published var showMediaPlayer = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    private var timer: Timer?
    
    // Playlist and controls
    var playlist: [String] = ["DeepSleep", "InnsomiaHeal", "DeepThinking"]
    @Published var currentIndex: Int = 0
    @Published var isShuffle: Bool = false
    @Published var isRepeat: Bool = false
    
    func play(songName: String) {
        if let idx = playlist.firstIndex(of: songName) {
            currentIndex = idx
        }
        guard let path = Bundle.main.path(forResource: songName, ofType: "mp3") else {
            print("Could not find \(songName).mp3")
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
    
    func togglePlayback(songName: String) {
        if isPlaying {
            audioPlayer?.pause()  // Change stop() to pause()
            isPlaying = false
            timer?.invalidate()
            timer = nil
        } else {
            if audioPlayer != nil {
                audioPlayer?.play()
                isPlaying = true
                startTimer()
            } else {
                play(songName: songName)
            }
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
        let songName = playlist[currentIndex]
        play(songName: songName)
    }
    
    func next() {
        if isShuffle {
            currentIndex = Int.random(in: 0..<playlist.count)
        } else {
            currentIndex = (currentIndex + 1) % playlist.count
        }
        playCurrent()
    }
    
    func previous() {
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
        if isRepeat {
            playCurrent()
        } else {
            next()
        }
    }
}