//
//  AppDataController.swift
//  Solace
//
//  Created by Kavyansh Pratap Singh on 05/05/25.
//

import Foundation
import Supabase


@MainActor class AppDataController{
    
    
    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://okpogigxwadkqbebrozl.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9rcG9naWd4d2Fka3FiZWJyb3psIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAzNzYzMzQsImV4cCI6MjA1NTk1MjMzNH0.6QNR3dAJ1bMiw0Y2D7SydcDgH91EBcr0U6OjzcnNGFI")
    
    static var sharedAppDataController = AppDataController()
    
    @Published var currentUser : User?
    
    
    @Published var alarms: [Alarm] = []
    @Published var likedSongs: [SoulfulEscapeSong] = []
    @Published var favouriteSongs: [SoulfulEscapeSong] = []
    @Published var userLoggedMood : [UserDailyMoodRecord] = []
    @Published var userPlaylists: [Playlist] = []
    @Published var userPlaylistSongs: [PlaylistSong] = []
    @Published var userStreak: [Streak] = []
    
    
    @Published var currentRecommendedSongs: [SoulfulEscapeSong] = []
    @Published var currentRecommendedTherapy : [PeacePointTherapy] = []
    
    
    @Published var completedSession: [CompletedSession] = []
    
    @Published var soulfulEscapesSongs: [SoulfulEscapeSong] = []
    @Published var peacePointTherapies: [PeacePointTherapy] = []
    
    func load() async throws {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }
        
        async let fetchAlarms = fetchAlarms()
        async let fetchLikedSongs = fetchLikedSongs()
        async let fetchFavouriteSongs = fetchFavouriteSongs()
        async let fetchUserLoggedMood = fetchUserLoggedMood()
        async let fetchUserPlaylists = fetchUserPlaylists()
        async let fetchUserPlaylistSongs = fetchUserPlaylistSongs()
        async let fetchUserStreak = fetchUserStreak()
        async let fetchCompletedSessions = fetchCompletedSessions()
        async let fetchSoulfulEscapesSongs = fetchSoulfulEscapesSongs()
        async let fetchPeacePointTherapies = fetchPeacePointTherapies()
        async let fetchRecommendedSongs = fetchRecommendedSongs()
        async let fetchRecommendedTherapies = fetchRecommendedTherapies()
        
        // Await all fetch operations
        let (alarms,
            likedSongs,
            favouriteSongs,
            userLoggedMood,
            userPlaylists,
            userPlaylistSongs,
            userStreak,
            completedSessions,
            soulfulEscapesSongs,
            peacePointTherapies,
            recommendedSongs,
            recommendedTherapies
        ) = try await (
            fetchAlarms,
            fetchLikedSongs,
            fetchFavouriteSongs,
            fetchUserLoggedMood,
            fetchUserPlaylists,
            fetchUserPlaylistSongs,
            fetchUserStreak,
            fetchCompletedSessions,
            fetchSoulfulEscapesSongs,
            fetchPeacePointTherapies,
            fetchRecommendedSongs,
            fetchRecommendedTherapies
        )
        
        // Update published properties
        self.alarms = alarms
        self.likedSongs = likedSongs
        self.favouriteSongs = favouriteSongs
        self.userLoggedMood = userLoggedMood
        self.userPlaylists = userPlaylists
        self.userPlaylistSongs = userPlaylistSongs
        self.userStreak = userStreak
        self.completedSession = completedSessions
        self.soulfulEscapesSongs = soulfulEscapesSongs
        self.peacePointTherapies = peacePointTherapies
        self.currentRecommendedSongs = recommendedSongs
        self.currentRecommendedTherapy = recommendedTherapies
    }
    
    //Func to fetch and display the first name of user
    func fetchUserName(userId: UUID) async throws -> String {
            // Query the User table for the specified user_id
            let user: User = try await supabase
                .from("User")
                .select("first_name")
                .eq("user_id", value: userId)
                .single() // Expect a single user
                .execute()
                .value
            
            // Update userData
            self.currentUser = user
            
            // Construct the full name
            var fullName = user.firstName
            return fullName
    }
    
    
    
    //Func to log the user mood
    func addMoodRecord(
            userId: UUID,
            date: Date = Date(),
            moodEmoji: String,
            moodCategory: MoodCategory
        ) async throws -> UserDailyMoodRecord {
            // Create a new mood record
            let newRecord = UserDailyMoodRecord(
                id: UUID(), // Will be overridden by gen_random_uuid() in the database
                userId: userId,
                date: Calendar.current.startOfDay(for: date), // Normalize to start of day
                moodEmoji: moodEmoji,
                moodCategory: moodCategory,
                isFeedbackSubmitted: nil,
                feedbackEmoji: nil,
                createdAt: Date(), feedbackMoodCategory: nil
            )
            
            // Insert the record into the UserDailyMoodRecord table and fetch the inserted record
            let insertedRecord: UserDailyMoodRecord = try await supabase
                .from("UserDailyMoodRecord")
                .insert(newRecord)
                .select() // Fetch the inserted record
                .single() // Expect a single record
                .execute()
                .value
            
            // Update the userLoggedMood array
            self.userLoggedMood.append(insertedRecord)
            
            return insertedRecord
        }
    
    
    
        
    //Func to log feedback mood
    func addFeedbackToMoodRecord(
        dailyRecordId: UUID,
        feedbackEmoji: String,
        feedbackMoodCategory: MoodCategory
    ) async throws {
        // Create the update payload as a Codable struct
        struct FeedbackUpdate: Encodable {
            let is_feedback_submitted: Bool
            let feedback_emoji: String
            let feedback_mood_category: MoodCategory
        }
        
        let updatePayload = FeedbackUpdate(
            is_feedback_submitted: true,
            feedback_emoji: feedbackEmoji,
            feedback_mood_category: feedbackMoodCategory
        )
        
        // Update the record in the UserDailyMoodRecord table
        let updatedRecord: UserDailyMoodRecord = try await supabase
            .from("UserDailyMoodRecord")
            .update(updatePayload)
            .eq("daily_record_id", value: dailyRecordId)
            .select()
            .single()
            .execute()
            .value
        
        // Update the userLoggedMood array
        if let index = userLoggedMood.firstIndex(where: { $0.id == dailyRecordId }) {
            userLoggedMood[index] = updatedRecord
        } else {
            userLoggedMood.append(updatedRecord)
        }
    }
        
    //Func to check if feedback mood is submitted or not
    func hasFeedbackForMoodRecord(dailyRecordId: UUID) async throws -> Bool {
        // Query the UserDailyMoodRecord table for the specified daily_record_id
        let record: UserDailyMoodRecord = try await supabase
            .from("UserDailyMoodRecord")
            .select("is_feedback_submitted, feedback_mood_category")
            .eq("daily_record_id", value: dailyRecordId)
            .single() // Expect a single record
            .execute()
            .value
        
        // Return true if feedback is submitted or a feedback mood category is set
        return record.isFeedbackSubmitted == true || record.feedbackMoodCategory != nil
    }
    
    
        
        
        // Fetch user data
        func fetchUser() async throws -> User {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            let user: User = try await supabase
                .from("User")
                .select()
                .eq("user_id", value: userId)
                .single()
                .execute()
                .value
            self.currentUser = user
            return user
        }
        
        // Fetch alarms
        private func fetchAlarms() async throws -> [Alarm] {
            guard let userId = currentUser?.id else {
                return []
            }
            let alarms: [Alarm] = try await supabase
                .from("Alarm")
                .select()
                .eq("user_id", value: userId)
                .order("time", ascending: true)
                .execute()
                .value
            return alarms
        }
        
        // Fetch liked songs
        private func fetchLikedSongs() async throws -> [SoulfulEscapeSong] {
            guard let userId = currentUser?.id else {
                return []
            }
            let songs: [SoulfulEscapeSong] = try await supabase
                .from("UserSongInteraction")
                .select("SoulfulEscapeSong(*)")
                .eq("user_id", value: userId)
                .eq("is_liked", value: true)
                .execute()
                .value
            return songs
        }
        
        // Fetch favourite songs
        private func fetchFavouriteSongs() async throws -> [SoulfulEscapeSong] {
            guard let userId = currentUser?.id else {
                return []
            }
            let songs: [SoulfulEscapeSong] = try await supabase
                .from("UserSongInteraction")
                .select("SoulfulEscapeSong(*)")
                .eq("user_id", value: userId)
                .eq("is_favourited", value: true)
                .execute()
                .value
            return songs
        }
        
        // Fetch user logged moods
        private func fetchUserLoggedMood() async throws -> [UserDailyMoodRecord] {
            guard let userId = currentUser?.id else {
                return []
            }
            let moods: [UserDailyMoodRecord] = try await supabase
                .from("UserDailyMoodRecord")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .execute()
                .value
            return moods
        }
        
        // Fetch user playlists
        private func fetchUserPlaylists() async throws -> [Playlist] {
            guard let userId = currentUser?.id else {
                return []
            }
            let playlists: [Playlist] = try await supabase
                .from("Playlist")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: true)
                .execute()
                .value
            return playlists
        }
        
        // Fetch user playlist songs
        private func fetchUserPlaylistSongs() async throws -> [PlaylistSong] {
            guard let userId = currentUser?.id else {
                return []
            }
            let playlistSongs: [PlaylistSong] = try await supabase
                .from("PlaylistSong")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            return playlistSongs
        }
        
        // Fetch user streak
        private func fetchUserStreak() async throws -> [Streak] {
            guard let userId = currentUser?.id else {
                return []
            }
            let streaks: [Streak] = try await supabase
                .from("Streak")
                .select()
                .eq("user_id", value: userId)
                .order("start_date", ascending: false)
                .execute()
                .value
            return streaks
        }
        
        // Fetch completed sessions
        private func fetchCompletedSessions() async throws -> [CompletedSession] {
            guard let userId = currentUser?.id else {
                return []
            }
            let sessions: [CompletedSession] = try await supabase
                .from("CompletedSession")
                .select()
                .eq("user_id", value: userId)
                .order("completed_at", ascending: false)
                .execute()
                .value
            return sessions
        }
        
        // Fetch all soulful escape songs
        private func fetchSoulfulEscapesSongs() async throws -> [SoulfulEscapeSong] {
            let songs: [SoulfulEscapeSong] = try await supabase
                .from("SoulfulEscapeSong")
                .select()
                .order("title", ascending: true)
                .execute()
                .value
            return songs
        }
        
        // Fetch all peace point therapies
        private func fetchPeacePointTherapies() async throws -> [PeacePointTherapy] {
            let therapies: [PeacePointTherapy] = try await supabase
                .from("PeacePointTherapy")
                .select()
                .order("title", ascending: true)
                .execute()
                .value
            return therapies
        }
        
        // Fetch recommended songs
        private func fetchRecommendedSongs() async throws -> [SoulfulEscapeSong] {
            guard let userId = currentUser?.id else {
                return []
            }
            let latestMood: UserDailyMoodRecord? = try await supabase
                .from("UserDailyMoodRecord")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .limit(1)
                .execute()
                .value
            
            if let moodCategory = latestMood?.moodCategory {
                let songs: [SoulfulEscapeSong] = try await supabase
                    .from("SoulfulEscapeSong")
                    .select()
                    .eq("mood_category", value: moodCategory.rawValue)
                    .limit(10)
                    .execute()
                    .value
                return songs
            }
            return []
        }
        
        // Fetch recommended therapies
        private func fetchRecommendedTherapies() async throws -> [PeacePointTherapy] {
            guard let userId = currentUser?.id else {
                return []
            }
            let latestMood: UserDailyMoodRecord? = try await supabase
                .from("UserDailyMoodRecord")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .limit(1)
                .execute()
                .value
    
            if let moodCategory = latestMood?.moodCategory {
                let therapies: [PeacePointTherapy] = try await supabase
                    .from("PeacePointTherapy")
                    .select()
                    .eq("mood_category", value: moodCategory.rawValue)
                    .limit(10)
                    .execute()
                    .value
                return therapies
            }
            return []
        }
        
        // Updated mood-related functions
        func addMoodRecord(
            date: Date = Date(),
            moodEmoji: String,
            moodCategory: MoodCategory
        ) async throws -> UserDailyMoodRecord {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            let newRecord = UserDailyMoodRecord(
                id: UUID(),
                userId: userId,
                date: Calendar.current.startOfDay(for: date),
                moodEmoji: moodEmoji,
                moodCategory: moodCategory,
                isFeedbackSubmitted: nil,
                feedbackEmoji: nil,
                createdAt: Date(),
                feedbackMoodCategory: nil
            )
            
            let insertedRecord: UserDailyMoodRecord = try await supabase
                .from("UserDailyMoodRecord")
                .insert(newRecord)
                .select()
                .single()
                .execute()
                .value
            
            self.userLoggedMood.append(insertedRecord)
            return insertedRecord
        }
        
        
        
        // Updated fetchUserName to use currentUser
        func fetchUserName() async throws -> String {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            let user: User = try await supabase
                .from("User")
                .select("first_name")
                .eq("user_id", value: userId)
                .single()
                .execute()
                .value
            self.currentUser = user
            return user.firstName
        }
    
}


