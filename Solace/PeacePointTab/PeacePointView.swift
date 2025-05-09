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

// Preview
struct PeacePointView_Previews: PreviewProvider {
    static var previews: some View {
        PeacePointView()
    }
}
