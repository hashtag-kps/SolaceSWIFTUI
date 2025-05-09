//
//  TherapyDetailView.swift
//  Solace
//
//  Created by Batch -1 on 06/05/25.
//
import SwiftUI
import AVKit
import AVFoundation


// MARK: - Therapy Detail View
struct TherapyDetailView: View {
    let therapy: PeacePointTherapy
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero image and video player
                ZStack {
                    if isPlaying, let player = player {
                        VideoPlayer(player: player)
                            .frame(height: 280)
                            .onDisappear {
                                player.pause()
                            }
                    } else {
                        Image("peaceImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 280)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.1),
                                        Color.black.opacity(0.5)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    
                    if !isPlaying {
                        // Play button with blur effect background
                        Button(action: {
                            playVideo()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Material.ultraThinMaterial)
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "play.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    // Title overlay at the bottom
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(therapy.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(therapy.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                            .shadow(radius: 2)
                            
                            Spacer()
                            
                            Text(therapy.category)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .padding(.trailing)
                        }
                    }
                }
                .frame(height: 280)
                
                // Content
                VStack(alignment: .leading, spacing: 24) {
                    // Session details
                    HStack(spacing: 30) {
                        VStack {
                            Image(systemName: "clock.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("10 min")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("With Audio")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Image(systemName: "figure.mind.and.body")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Beginner")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6))
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // About this therapy
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About this therapy")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(therapy.description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    
                    // Benefits section removed as requested
                    
                    // Recommended section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You might also like")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                recommendationCard(title: "Deep Breathing", category: "Breathing")
                                recommendationCard(title: "Sleep Meditation", category: "Meditation")
                                recommendationCard(title: "Gentle Yoga", category: "Yoga")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                }
            }
        }
    }
    
    // Benefits row removed as requested
    
    private func recommendationCard(title: String, category: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Fixed the error by replacing Color with Rectangle
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    Image(systemName: "waveform")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.8))
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(category)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(10)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6))
        )
        .frame(width: 150)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func playVideo() {
        // Preload player to fix the initial content display issue
        let filename = "Foot massage"
        
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp4") {
            // Create player and load asset immediately
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            
            // Ensure content is preloaded before displaying
            let loadKeys = ["playable"]
            playerItem.asset.loadValuesAsynchronously(forKeys: loadKeys) {
                DispatchQueue.main.async {
                    // Check if successfully loaded
                    var error: NSError? = nil
                    let status = playerItem.asset.statusOfValue(forKey: "playable", error: &error)
                    
                    if status == .loaded {
                        self.player?.play()
                        self.isPlaying = true
                    } else {
                        print("Failed to load video: \(error?.localizedDescription ?? "unknown error")")
                    }
                }
            }
        } else {
            // Handle the case where the video file doesn't exist
            print("Video file not found: \(therapy.videoName)")
        }
    }
}
