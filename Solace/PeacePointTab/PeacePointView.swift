//
//  PeacePointView.swift
//  Solace
//
//  Created by Batch -1 on 05/05/25.
//

import SwiftUI
import AVKit

struct PeacePointView: View {
    @StateObject private var viewModel = PeacePointViewModel()
    @State private var selectedTherapy: PeacePointTherapy? = nil
    @State private var showingSearchView = false
    @State private var isMoodIconHighlighted = false
    @State private var showingDetailView = false
    
    private let categories = ["All", "Meditation", "Breathing", "Yoga", "Relaxation"]
    
    // Define the gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(.systemGroupedBackground), Color(.systemBackground)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient for the entire view
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar (pinned at the top)
                    searchBar
                        .padding(.vertical, 8)
                        .background(Color.clear)
                    
                    // Main scrollable content
                    ScrollView {
                        VStack(spacing: 16) {
                            // Category filter (scrolls away)
                            categoryPicker
                                .padding(.top, 8)
                            
                            // Featured therapy section
                            featuredTherapySection
                            
                            // All therapies grid
                            therapiesGrid
                        }
                        .padding(.bottom)
                        .background(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isMoodIconHighlighted.toggle()
                    }) {
                        Image(systemName: "face.smiling")
                            .foregroundColor(isMoodIconHighlighted ? .blue : .primary)
                    }
                }
            }
            .sheet(isPresented: $showingSearchView) {
                SearchView(searchText: $viewModel.searchText, therapies: viewModel.therapies)
                    .transition(.opacity)
            }
            .sheet(isPresented: $showingDetailView) {
                if let therapy = selectedTherapy {
                    TherapyDetailView(therapy: therapy, onComplete: {
                        viewModel.markTherapyAsCompleted(therapy: therapy)
                    })
                    .edgesIgnoringSafeArea(.top)
                }
            }
        }
    }
    
    // MARK: - Components
    
    private var searchBar: some View {
        Button(action: {
            showingSearchView = true
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                Text(viewModel.searchText.isEmpty ? "Search therapies" : viewModel.searchText)
                    .foregroundColor(viewModel.searchText.isEmpty ? .gray : .primary)
                
                Spacer()
                
                if !viewModel.searchText.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground).opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        viewModel.selectedCategory = category
                    }) {
                        Text(category)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    private var featuredTherapySection: some View {
        VStack(alignment: .leading) {
            Text("Featured")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            if let featured = viewModel.getFeaturedTherapy() {
                ZStack {
                    Image("peaceImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(16)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .cornerRadius(16)
                        )
                    
                    // Centered play button
                    Button(action: {
                        selectedTherapy = featured
                        showingDetailView = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Text overlay at the bottom
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text(featured.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(featured.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                }
                .padding(.horizontal)
                .onTapGesture {
                    selectedTherapy = featured
                    showingDetailView = true
                }
            }
        }
    }
    
    private var therapiesGrid: some View {
        VStack(alignment: .leading) {
            Text("All Therapies")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.getFilteredTherapies()) { therapy in
                    therapyCard(therapy: therapy)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private func therapyCard(therapy: PeacePointTherapy) -> some View {
        Button(action: {
            selectedTherapy = therapy
            showingDetailView = true
        }) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .center) {
                    Image("peaceImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .cornerRadius(16)
                        .clipped()
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(therapy.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(therapy.subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(therapy.category)
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 6)
                .frame(height: 70)
            }
            .frame(maxWidth: .infinity, maxHeight: 190)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Helper Shape for Rounded Corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Extension for applying rounded corners to specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

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

// MARK: - Search View
struct SearchView: View {
    @Binding var searchText: String
    let therapies: [PeacePointTherapy]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search input
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search therapies", text: $searchText)
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                
                // Suggestions
                if suggestions.isEmpty && !searchText.isEmpty {
                    Text("No results found")
                        .foregroundColor(.secondary)
                        .font(.body)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                suggestionCard(suggestion: suggestion)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .scrollContentBackground(.hidden)
                    .animation(.easeInOut, value: searchText)
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func suggestionCard(suggestion: String) -> some View {
        Button(action: {
            searchText = suggestion
        }) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .center) {
                    Color.gray.opacity(0.2)
                        .frame(height: 100)
                        .cornerRadius(16)
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                
                Text(suggestion)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 6)
                    .frame(height: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: 140)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var suggestions: [String] {
        let allSuggestions = therapies.map { $0.title } + therapies.map { $0.category }
        let uniqueSuggestions = Array(Set(allSuggestions)).sorted()
        return searchText.isEmpty ? uniqueSuggestions.prefix(4).map { $0 } : uniqueSuggestions.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(4).map { $0 }
    }
}

// Preview
struct PeacePointView_Previews: PreviewProvider {
    static var previews: some View {
        PeacePointView()
    }
}
