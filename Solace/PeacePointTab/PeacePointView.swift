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
                            
                            // Selected therapy video player (if any)
                            if let therapy = selectedTherapy {
                                videoPlayerView(for: therapy)
                                    .padding(.horizontal)
                            }
                            
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
                            .foregroundColor(isMoodIconHighlighted ? AppColors.appleMusicHighlight : .primary)
                    }
                }
            }
            .sheet(isPresented: $showingSearchView) {
                SearchView(searchText: $viewModel.searchText, therapies: viewModel.therapies)
                    .transition(.opacity)
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
                    .foregroundColor(.primary)
                
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
                        selectedTherapy = selectedTherapy == featured ? nil : featured
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
            selectedTherapy = selectedTherapy == therapy ? nil : therapy
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
    
    private func videoPlayerView(for therapy: PeacePointTherapy) -> some View {
        VStack {
            Text(therapy.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            ZStack {
                VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "Foot massage", withExtension: "mp4")!))
                    .frame(height: 250)
                    .cornerRadius(16)
                
                Button(action: {
                    if let url = Bundle.main.url(forResource: therapy.videoName, withExtension: "mp4") {
                        let player = AVPlayer(url: url)
                        player.play()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text(therapy.subtitle)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text("About this therapy")
                    .font(.headline)
                
                Text(therapy.description)
                    .font(.body)
                    .lineSpacing(5)
                
                Divider()
                
                Text("Category: \(therapy.category)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.vertical)
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
                    .foregroundColor(.primary)
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

// MARK: - Foot Massage Video Player
struct FootMassageVideoPlayer: View {
    @State private var player: AVPlayer
    
    init() {
        if let videoURL = Bundle.main.url(forResource: "Foot massage", withExtension: "mp4") {
            self._player = State(initialValue: AVPlayer(url: videoURL))
        } else {
            self._player = State(initialValue: AVPlayer())
        }
    }
    
    var body: some View {
        VideoPlayer(player: player)
    }
}

// Preview
struct PeacePointView_Previews: PreviewProvider {
    static var previews: some View {
        PeacePointView()
    }
}
