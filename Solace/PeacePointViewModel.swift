//
//  PeacePointViewModel.swift
//  Solace
//
//  Created by Batch -1 on 02/05/25.
//


//
//  PeacePointViewModel.swift
//  Solace
//
//  Created on 02/05/25.
//

import Foundation
import Combine
import SwiftUI

class PeacePointViewModel: ObservableObject {
    // Published properties for UI updates
    @Published var therapies: [PeacePointTherapy] = []
    @Published var selectedCategory: String = "All"
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Categories
    let categories = ["All", "Meditation", "Breathing", "Yoga", "Relaxation"]
    
    // Current user
    private var userId: UUID?
    
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init(userId: UUID? = nil) {
        self.userId = userId
        loadTherapies()
    }
    
    // MARK: - Data Methods
    
    /// Loads therapy data - in a real app, this would fetch from API or CoreData
    func loadTherapies() {
        isLoading = true
        
        // Simulate a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // In a real app, this would be an API call or database fetch
            self.therapies = self.mockTherapies()
            self.isLoading = false
        }
    }
    
    /// Creates mock therapy data for development
    private func mockTherapies() -> [PeacePointTherapy] {
        let dateFormatter = ISO8601DateFormatter()
        
        return [
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
    
    /// Filters therapies based on selected category and search text
    func getFilteredTherapies() -> [PeacePointTherapy] {
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
    
    /// Returns featured therapy (currently just the first item)
    func getFeaturedTherapy() -> PeacePointTherapy? {
        return therapies.first
    }
    
    // MARK: - User Actions
    
    /// Records a completed therapy session
    func markTherapyAsCompleted(therapy: PeacePointTherapy) {
        guard let userId = userId else {
            errorMessage = "User not logged in"
            return
        }
        
        // Create completed session record
        let completedSession = CompletedSession(
            id: UUID(),
            userId: userId,
            songIds: nil,
            therapyIds: [therapy.id],
            progress: 1.0, // Fully completed
            completedAt: Date()
        )
        
        // In a real app, this would save to a database or API
        print("Session completed and saved: \(completedSession)")
        
        // Here you might award points to the user
        awardPointsForCompletion()
    }
    
    /// Awards points to the user for completing a therapy session
    private func awardPointsForCompletion() {
        // In a real app, this would update the user's points in a database
        print("User awarded points for completing a therapy session")
    }
}