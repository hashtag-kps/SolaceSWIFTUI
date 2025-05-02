//
//  PeacePointView.swift
//  Solace
//
//  Created on 02/05/25.
//

import SwiftUI
import AVKit

struct PeacePointView: View {
    // Sample data for the view
    @State private var therapies: [PeacePointTherapy] = []
    @State private var selectedCategory: String = "All"
    @State private var searchText: String = ""
    @State private var selectedTherapy: PeacePointTherapy? = nil
    @State private var showingVideoPlayer = false
    
    private let categories = ["All", "Meditation", "Breathing", "Yoga", "Relaxation"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                searchBar
                
                // Category filter
                categoryPicker
                
                // Main content
                ScrollView {
                    // Featured therapy section
                    featuredTherapySection
                    
                    // All therapies grid
                    therapiesGrid
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Peace Point")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add action for favorites or settings
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingVideoPlayer) {
                if let therapy = selectedTherapy {
                    videoPlayerView(for: therapy)
                }
            }
            .onAppear {
                loadSampleData()
            }
        }
    }
    
    // MARK: - Components
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search therapies", text: $searchText)
                .foregroundColor(.primary)
            
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
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .padding()
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
    
    private var featuredTherapySection: some View {
        VStack(alignment: .leading) {
            Text("Featured")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top)
            
            if let featured = therapies.first {
                ZStack(alignment: .bottom) {
                    // Image with gradient overlay
                    Image(featured.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Play button overlay
                    Button(action: {
                        selectedTherapy = featured
                        showingVideoPlayer = true
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
                    .offset(y: -30)
                    
                    // Text overlays at bottom
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
                .padding(.top)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredTherapies) { therapy in
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
            showingVideoPlayer = true
        }) {
            VStack(alignment: .leading) {
                ZStack(alignment: .center) {
                    Image(therapy.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .cornerRadius(10)
                        .clipped()
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(therapy.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(therapy.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(therapy.category)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                }
                .padding(.vertical, 8)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
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
            
            // Using AVPlayer for video playback
            if let url = Bundle.main.url(forResource: therapy.videoName, withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 250)
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }
            
            ScrollView {
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
            
            Button(action: {
                // Save as completed session
                saveCompletedSession(therapy: therapy)
            }) {
                Text("Mark as Completed")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    // MARK: - Helper Methods
    
    // Filter therapies based on selected category and search text
    private var filteredTherapies: [PeacePointTherapy] {
        var result = therapies
        
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    // Load sample data
    private func loadSampleData() {
        // Create sample PeacePointTherapy objects
        let dateFormatter = ISO8601DateFormatter()
        
        therapies = [
            PeacePointTherapy(
                id: UUID(),
                imageName: "meditation_1",
                title: "Morning Mindfulness",
                subtitle: "Start your day with 10 minutes of calm",
                videoName: "morning_meditation",
                description: "This meditation helps you begin your day with a clear mind and positive intention. Perfect for beginners, this guided session will help you establish a daily mindfulness practice.",
                category: "Meditation",
                createdAt: dateFormatter.date(from: "2025-01-01T00:00:00Z") ?? Date()
            ),
            PeacePointTherapy(
                id: UUID(),
                imageName: "breathing_1",
                title: "Deep Breathing Exercise",
                subtitle: "Reduce stress with 4-7-8 breathing",
                videoName: "breathing_technique",
                description: "This breathing technique can help reduce anxiety, help you fall asleep, and re-center yourself during stressful moments. Practice this exercise anywhere, anytime you need to find calm.",
                category: "Breathing",
                createdAt: dateFormatter.date(from: "2025-01-02T00:00:00Z") ?? Date()
            ),
            PeacePointTherapy(
                id: UUID(),
                imageName: "yoga_1",
                title: "Gentle Yoga Flow",
                subtitle: "15-minute rejuvenating flow for all levels",
                videoName: "gentle_yoga",
                description: "This gentle yoga sequence is perfect for beginners or when you need a restorative practice. Focus on breath and gentle movement to release tension in your body and mind.",
                category: "Yoga",
                createdAt: dateFormatter.date(from: "2025-01-03T00:00:00Z") ?? Date()
            ),
            PeacePointTherapy(
                id: UUID(),
                imageName: "relaxation_1",
                title: "Body Scan Relaxation",
                subtitle: "Release tension with progressive relaxation",
                videoName: "body_scan",
                description: "This progressive relaxation technique helps you identify and release tension throughout your body. Perfect for before sleep or anytime you need to deeply relax.",
                category: "Relaxation",
                createdAt: dateFormatter.date(from: "2025-01-04T00:00:00Z") ?? Date()
            ),
            PeacePointTherapy(
                id: UUID(),
                imageName: "meditation_2",
                title: "Gratitude Meditation",
                subtitle: "Cultivate appreciation and positivity",
                videoName: "gratitude_practice",
                description: "This guided meditation helps you focus on gratitude and appreciation, which can improve your mood and outlook. Regular practice can help reduce negative thinking patterns.",
                category: "Meditation",
                createdAt: dateFormatter.date(from: "2025-01-05T00:00:00Z") ?? Date()
            ),
            PeacePointTherapy(
                id: UUID(),
                imageName: "yoga_2",
                title: "Desk Yoga Break",
                subtitle: "5-minute stretch for work breaks",
                videoName: "desk_yoga",
                description: "Take a quick break from work with these simple stretches you can do right at your desk. Relieve tension in your neck, shoulders, and back from sitting too long.",
                category: "Yoga",
                createdAt: dateFormatter.date(from: "2025-01-06T00:00:00Z") ?? Date()
            )
        ]
    }
    
    // Save completed session
    private func saveCompletedSession(therapy: PeacePointTherapy) {
        // In a real app, you would save to Core Data or other persistence
        let completedSession = CompletedSession(
            id: UUID(),
            userId: UUID(), // In real app, use actual user ID
            songIds: nil,
            therapyIds: [therapy.id],
            progress: 1.0, // Completed
            completedAt: Date()
        )
        
        print("Session completed: \(completedSession)")
        // Implement actual saving logic here
    }
}

// Preview
struct PeacePointView_Previews: PreviewProvider {
    static var previews: some View {
        PeacePointView()
    }
}
