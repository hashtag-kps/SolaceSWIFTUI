import SwiftUI
import AVKit

struct PeacePointView: View {
    @StateObject private var viewModel = PeacePointViewModel()
    @State private var selectedTherapy: PeacePointTherapy? = nil
    @State private var showingVideoPlayer = false
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
                        .background(Color.clear) // Make the search bar background clear to show the gradient
                    
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
                        .background(Color.clear) // Ensure ScrollView background is clear
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
            .sheet(isPresented: $showingVideoPlayer) {
                if let therapy = selectedTherapy {
                    videoPlayerView(for: therapy)
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
            .background(Color(.systemBackground).opacity(0.8)) // Slightly transparent for contrast
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
                ZStack(alignment: .bottom) {
                    Image(featured.imageName)
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
            showingVideoPlayer = true
        }) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .center) {
                    Image(therapy.imageName)
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(therapy.title)
                        .font(.subheadline) // Reduced from .headline
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(therapy.subtitle)
                        .font(.caption) // Reduced from .subheadline
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    Text(therapy.category)
                        .font(.caption2) // Reduced from .caption
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .frame(minHeight: 100) // Adjusted height due to smaller text
            }
            .frame(maxWidth: .infinity, maxHeight: 230) // Adjusted overall card height
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
            
            if let url = Bundle.main.url(forResource: therapy.videoName, withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 250)
                    .cornerRadius(16)
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
                viewModel.markTherapyAsCompleted(therapy: therapy)
            }) {
                Text("Mark as Completed")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding()
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
                        .frame(height: 120)
                        .cornerRadius(16)
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                
                Text(suggestion)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: .infinity, maxHeight: 180)
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
