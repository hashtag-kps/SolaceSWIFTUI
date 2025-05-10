//
//  SearchView.swift
//  Solace
//
//  Created by Batch -1 on 06/05/25.
//imp
import SwiftUI


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
