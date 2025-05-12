//
//  AppDataController.swift
//  Solace
//
//  Created by Kavyansh Pratap Singh on 05/05/25.
//

import Foundation
import Supabase



extension Date {
    var iso8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}




@MainActor class AppDataController{
    
    
    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://okpogigxwadkqbebrozl.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9rcG9naWd4d2Fka3FiZWJyb3psIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAzNzYzMzQsImV4cCI6MjA1NTk1MjMzNH0.6QNR3dAJ1bMiw0Y2D7SydcDgH91EBcr0U6OjzcnNGFI")
    
    static var sharedAppDataController = AppDataController()
    
    @Published var currentUser : User?
    
    
    @Published var alarms: [Alarm] = []
    @Published var likedSongs: [LikedSong] = []
    @Published var favouriteSongs: [FavoriteSong] = []
    @Published var userLoggedMood : [UserDailyMoodRecord] = []
    @Published var lastMoodFeedbackPerDay: [UserDailyMoodRecord] = []
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
        async let fetchLastMoodFeedback = fetchLastMoodFeedbackPerDay()
        
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
            recommendedTherapies,
            lastMoodFeedback
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
            fetchRecommendedTherapies,
            fetchLastMoodFeedback
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
    
    
    //MARK: Default Fetch & Load Functions
    
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
    private func fetchLikedSongs() async throws -> [LikedSong] {
        guard let userId = currentUser?.id else { return [] }
        
        let songs: [LikedSong] = try await supabase
            .from("UserSongInteraction")
            .select("""
                interaction_id,
                user_id,
                song_id,
                created_at,
                SoulfulEscapeSong!song_id(
                    song_id,
                    image_name,
                    title,
                    subtitle,
                    duration,
                    category,
                    like_count,
                    file_url,
                    created_at AS song_created_at
                )
            """)
            .eq("user_id", value: userId)
            .eq("is_liked", value: true)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return songs
    }

    // Fetch favourite songs
    private func fetchFavouriteSongs() async throws -> [FavoriteSong] {
        guard let userId = currentUser?.id else { return [] }
        
        let songs: [FavoriteSong] = try await supabase
            .from("UserSongInteraction")
            .select("""
                interaction_id,
                user_id,
                song_id,
                created_at,
                SoulfulEscapeSong!song_id(
                    song_id,
                    image_name,
                    title,
                    subtitle,
                    duration,
                    category,
                    like_count,
                    file_url,
                    created_at AS song_created_at
                )
            """)
            .eq("user_id", value: userId)
            .eq("is_favourited", value: true)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return songs
    }
    
    // Fetch user logged moods
    private func fetchUserLoggedMood() async throws -> [UserDailyMoodRecord] {
        guard let userId = currentUser?.id else {
            return []
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let moods: [UserDailyMoodRecord] = try await supabase
            .from("UserDailyMoodRecord")
            .select()
            .eq( "user_id", value: userId)
            .eq( "date", value: today)
            .order( "created_at", ascending: false)
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
    func fetchSoulfulEscapesSongs(isMoodFiltered: Bool = false) async throws -> [SoulfulEscapeSong] {
        guard let userId = currentUser?.id else {
            // Return empty array if no user is logged in
            self.soulfulEscapesSongs = []
            return []
        }
        
        let songs: [SoulfulEscapeSong]
        if isMoodFiltered {
            // Fetch the latest mood record
            let latestMood: [UserDailyMoodRecord] = try await supabase
                .from("UserDailyMoodRecord")
                .select("mood_category")
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .limit(1)
                .execute()
                .value
            
            if let moodCategory = latestMood.first?.moodCategory {
                // Fetch songs matching the latest mood category
                songs = try await supabase
                    .from("SoulfulEscapeSong")
                    .select()
                    .eq("category", value: moodCategory.rawValue)
                    .order("title", ascending: true)
                    .execute()
                    .value
            } else {
                // No mood recorded, return empty array
                songs = []
            }
        } else {
            // Fetch all songs
            songs = try await supabase
                .from("SoulfulEscapeSong")
                .select()
                .order("title", ascending: true)
                .execute()
                .value
        }
        
        // Update the published array
        self.soulfulEscapesSongs = songs
        return songs
    }
    
    
    // Fetch all peace point therapies
    func fetchPeacePointTherapies(isMoodFiltered: Bool = false) async throws -> [PeacePointTherapy] {
            guard let userId = currentUser?.id else {
                // Return empty array if no user is logged in
                self.peacePointTherapies = []
                return []
            }
            
            let therapies: [PeacePointTherapy]
            if isMoodFiltered {
                // Fetch the latest mood record
                let latestMood: [UserDailyMoodRecord] = try await supabase
                    .from("UserDailyMoodRecord")
                    .select("mood_category")
                    .eq("user_id", value: userId)
                    .order("created_at", ascending: false)
                    .limit(1)
                    .execute()
                    .value
                
                if let moodCategory = latestMood.first?.moodCategory {
                    // Fetch therapies matching the latest mood category
                    therapies = try await supabase
                        .from("PeacePointTherapy")
                        .select()
                        .eq("category", value: moodCategory.rawValue)
                        .order("title", ascending: true)
                        .execute()
                        .value
                } else {
                    // No mood recorded, return empty array
                    therapies = []
                }
            } else {
                // Fetch all therapies
                therapies = try await supabase
                    .from("PeacePointTherapy")
                    .select()
                    .order("title", ascending: true)
                    .execute()
                    .value
            }
            
            // Update the published array
            self.peacePointTherapies = therapies
            return therapies
        }
    

    
    // Fetch recommended songs (updated to fetch 2 random songs based on today's last mood)
       private func fetchRecommendedSongs() async throws -> [SoulfulEscapeSong] {
           guard let userId = currentUser?.id else {
               return []
           }
           
           // Get the start of the current day
           let today = Calendar.current.startOfDay(for: Date())
           
           // Fetch the latest mood record for today
           let latestMood: [UserDailyMoodRecord] = try await supabase
               .from("UserDailyMoodRecord")
               .select()
               .eq("user_id", value: userId)
               .eq("date", value: today)
               .order("created_at", ascending: false)
               .limit(1)
               .execute()
               .value
           
           if let moodCategory = latestMood.first?.moodCategory {
               // Fetch 2 random songs matching the mood category
               let songs: [SoulfulEscapeSong] = try await supabase
                   .from("SoulfulEscapeSong")
                   .select()
                   .eq("category", value: moodCategory.rawValue)
                   .order("random()", referencedTable: "SoulfulEscapeSong")
                   .limit(2)
                   .execute()
                   .value
               return songs
           }
           
           return []
       }
    

    
    
    // Fetch recommended therapies (updated to fetch 2 random therapies based on today's last mood)
        private func fetchRecommendedTherapies() async throws -> [PeacePointTherapy] {
            guard let userId = currentUser?.id else {
                return []
            }
            
            // Get the start of the current day
            let today = Calendar.current.startOfDay(for: Date())
            
            // Fetch the latest mood record for today
            let latestMood: [UserDailyMoodRecord] = try await supabase
                .from("UserDailyMoodRecord")
                .select()
                .eq("user_id", value: userId)
                .eq("date", value: today)
                .order("created_at", ascending: false)
                .limit(1)
                .execute()
                .value
            
            if let moodCategory = latestMood.first?.moodCategory {
                // Fetch 2 random therapies matching the mood category
                let therapies: [PeacePointTherapy] = try await supabase
                    .from("PeacePointTherapy")
                    .select()
                    .eq("category", value: moodCategory.rawValue)
                    .order("random()", referencedTable: "PeacePointTherapy")
                    .limit(2)
                    .execute()
                    .value
                return therapies
            }
            
            return []
        }
    
    

    
    // Fetch the last mood feedback for each day
    func fetchLastMoodFeedbackPerDay() async throws -> [UserDailyMoodRecord] {
        guard let userId = currentUser?.id else {
            return []
        }
            
        let records: [UserDailyMoodRecord] = try await supabase
            .from("UserDailyMoodRecord")
            .select()
            .eq("user_id", value: userId)
            .in("is_feedback_submitted", values: [true]) // Only records with feedback
            .execute()
            .value
            
        // Group by date and take the latest record based on created_at
        let groupedByDate = Dictionary(grouping: records) { record in
            Calendar.current.startOfDay(for: record.date)
        }
            
        let latestRecords = groupedByDate.mapValues { records in
            records.max { $0.createdAt < $1.createdAt }!
        }.values.sorted { $0.date > $1.date }
            
        return Array(latestRecords)
    }
    
    
    
    // Func to fetch User's first name
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

    
    
    
    
    
    
    
    //MARK: Home Tab FUnction
    
    
    
    
    
    

    
    //Func to log the user mood
//    func addMoodRecord(
//            userId: UUID,
//            date: Date = Date(),
//            moodEmoji: String,
//            moodCategory: MoodCategory
//        ) async throws -> UserDailyMoodRecord {
//            // Create a new mood record
//            let newRecord = UserDailyMoodRecord(
//                id: UUID(), // Will be overridden by gen_random_uuid() in the database
//                userId: userId,
//                date: Calendar.current.startOfDay(for: date), // Normalize to start of day
//                moodEmoji: moodEmoji,
//                moodCategory: moodCategory,
//                isFeedbackSubmitted: nil,
//                feedbackEmoji: nil,
//                createdAt: Date(), feedbackMoodCategory: nil
//            )
//            
//            // Insert the record into the UserDailyMoodRecord table and fetch the inserted record
//            let insertedRecord: UserDailyMoodRecord = try await supabase
//                .from("UserDailyMoodRecord")
//                .insert(newRecord)
//                .select() // Fetch the inserted record
//                .single() // Expect a single record
//                .execute()
//                .value
//            
//            // Update the userLoggedMood array
//            self.userLoggedMood.append(insertedRecord)
//            
//            // Refresh recommended songs and therapies if the mood is for today
//            if Calendar.current.isDate(insertedRecord.date, inSameDayAs: Date()) {
//                async let songs = fetchRecommendedSongs()
//                async let therapies = fetchRecommendedTherapies()
//                let (recommendedSongs, recommendedTherapies) = try await (songs, therapies)
//                self.currentRecommendedSongs = recommendedSongs
//                self.currentRecommendedTherapy = recommendedTherapies
//            }
//            
//            return insertedRecord
//        }
    
    
    func addMoodRecord(
           userId: UUID,
           date: Date = Date(),
           moodEmoji: String,
           moodCategory: MoodCategory
       ) async throws -> UserDailyMoodRecord {
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
           
           // Handle points and streak logic for the first mood entry of the day
           let today = Calendar.current.startOfDay(for: Date())
           if Calendar.current.isDate(insertedRecord.date, inSameDayAs: today) {
               // Check if this is the first mood entry for today
               let existingMoods: [UserDailyMoodRecord] = try await supabase
                   .from("UserDailyMoodRecord")
                   .select()
                   .eq("user_id", value: userId)
                   .eq("date", value: today)
                   .order("created_at", ascending: true)
                   .execute()
                   .value
               
               if existingMoods.count == 1 { // This is the first mood entry today
                   // Increment user points by 5
                   let currentUser: User = try await supabase
                       .from("User")
                       .select("user_points")
                       .eq("user_id", value: userId)
                       .single()
                       .execute()
                       .value
                   let newPoints = currentUser.userPoints + 5
                   try await supabase
                       .from("User")
                       .update(["user_points": newPoints])
                       .eq("user_id", value: userId)
                       .execute()
                   
                   // Manage streak
                   let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
                   let previousDayMoods: [UserDailyMoodRecord] = try await supabase
                       .from("UserDailyMoodRecord")
                       .select()
                       .eq("user_id", value: userId)
                       .eq("date", value: yesterday)
                       .execute()
                       .value
                   
                   let currentStreak: [Streak] = try await supabase
                       .from("Streak")
                       .select()
                       .eq("user_id", value: userId)
                       .order("updated_at", ascending: false)
                       .limit(1)
                       .execute()
                       .value
                   
                   if let streak = currentStreak.first {
                       let updatePayload: [String: String]
                       if !previousDayMoods.isEmpty {
                           // Continuous streak: increment streak_count
                           updatePayload = [
                               "streak_count": String(streak.streakCount + 1),
                               "longest_streak": String(max(streak.longestStreak, streak.streakCount + 1)),
                               "updated_at": Date().iso8601
                           ]
                       } else {
                           // Streak broken: update longest_streak if necessary, reset streak_count
                           updatePayload = [
                               "streak_count": "0",
                               "longest_streak": String(max(streak.longestStreak, streak.streakCount)),
                               "updated_at": Date().iso8601
                           ]
                       }
                       try await supabase
                           .from("Streak")
                           .update(updatePayload)
                           .eq("user_id", value: userId)
                           .eq("streak_id", value: streak.id)
                           .execute()
                       
                       // Update userStreak array
                       let updatedStreaks: [Streak] = try await fetchUserStreak()
                       self.userStreak = updatedStreaks
                   } else {
                       // Create new streak record
                       let newStreak = Streak(
                           id: UUID(),
                           userId: userId,
                           streakCount: 1,
                           longestStreak: 1,
                           updatedAt: Date()
                       )
                       try await supabase
                           .from("Streak")
                           .insert(newStreak)
                           .execute()
                       self.userStreak.append(newStreak)
                   }
               }
               
               // Refresh recommended songs and therapies (existing logic)
               async let songs = fetchRecommendedSongs()
               async let therapies = fetchRecommendedTherapies()
               let (recommendedSongs, recommendedTherapies) = try await (songs, therapies)
               self.currentRecommendedSongs = recommendedSongs
               self.currentRecommendedTherapy = recommendedTherapies
           }
           
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
    
    
    
    
    
    
    
    
    //MARK: Soulf Escapes Tab Functions

    
    
    
    
    
    //Func to like a song
    func likeSong(songId: UUID) async throws -> LikedSong {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        // Verify song exists
        let songExists: [SoulfulEscapeSong] = try await supabase
            .from("SoulfulEscapeSong")
            .select("song_id")
            .eq("song_id", value: songId)
            .execute()
            .value
        guard !songExists.isEmpty else {
            throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Song not found"])
        }

        // Check for existing interaction
        let existingInteractions: [UserSongInteraction] = try await supabase
            .from("UserSongInteraction")
            .select()
            .eq("user_id", value: userId)
            .eq("song_id", value: songId)
            .execute()
            .value

        let likedSong: LikedSong
        if let interaction = existingInteractions.first {
            // Update existing interaction if not already liked
            if !interaction.isLiked {
                let updatePayload = UserSongInteractionUpdate(
                    is_liked: true,
                    is_favourited: interaction.isFavourited, // Preserve is_favourited
                    updated_at: Date().iso8601
                )
                likedSong = try await supabase
                    .from("UserSongInteraction")
                    .update(updatePayload)
                    .eq("interaction_id", value: interaction.interactionId)
                    .select("""
                        interaction_id,
                        user_id,
                        song_id,
                        created_at,
                        SoulfulEscapeSong!song_id(
                            song_id,
                            image_name,
                            title,
                            subtitle,
                            duration,
                            category,
                            like_count,
                            file_url,
                            created_at AS song_created_at
                        )
                    """)
                    .single()
                    .execute()
                    .value

                // Update like_count
                let currentSong: SoulfulEscapeSong = try await supabase
                    .from("SoulfulEscapeSong")
                    .select()
                    .eq("song_id", value: songId)
                    .single()
                    .execute()
                    .value
                try await supabase
                    .from("SoulfulEscapeSong")
                    .update(["like_count": currentSong.likeCount + 1])
                    .eq("song_id", value: songId)
                    .execute()
            } else {
                // Already liked, fetch current state
                likedSong = try await supabase
                    .from("UserSongInteraction")
                    .select("""
                        interaction_id,
                        user_id,
                        song_id,
                        created_at,
                        SoulfulEscapeSong!song_id(
                            song_id,
                            image_name,
                            title,
                            subtitle,
                            duration,
                            category,
                            like_count,
                            file_url,
                            created_at AS song_created_at
                        )
                    """)
                    .eq("interaction_id", value: interaction.interactionId)
                    .single()
                    .execute()
                    .value
            }

            // Update likedSongs array
            if let index = likedSongs.firstIndex(where: { $0.id == likedSong.id }) {
                likedSongs[index] = likedSong
            } else {
                likedSongs.append(likedSong)
            }
        } else {
            // Insert new interaction
            let insertPayload = try UserSongInteractionInsert(
                user_id: userId,
                song_id: songId,
                is_liked: true,
                is_favourited: false, // Default to false
                created_at: Date(),
                updated_at: Date()
            )
            likedSong = try await supabase
                .from("UserSongInteraction")
                .insert(insertPayload)
                .select("""
                    interaction_id,
                    user_id,
                    song_id,
                    created_at,
                    SoulfulEscapeSong!song_id(
                        song_id,
                        image_name,
                        title,
                        subtitle,
                        duration,
                        category,
                        like_count,
                        file_url,
                        created_at AS song_created_at
                    )
                """)
                .single()
                .execute()
                .value

            // Update like_count
            let currentSong: SoulfulEscapeSong = try await supabase
                .from("SoulfulEscapeSong")
                .select()
                .eq("song_id", value: songId)
                .single()
                .execute()
                .value
            try await supabase
                .from("SoulfulEscapeSong")
                .update(["like_count": currentSong.likeCount + 1])
                .eq("song_id", value: songId)
                .execute()

            likedSongs.append(likedSong)
        }

        likedSongs.sort { $0.interactionCreatedAt > $1.interactionCreatedAt }
        return likedSong
    }

        
    //Func to unlike the song
    func unlikeSong(songId: UUID) async throws {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        // Check for existing interaction
        let interactions: [UserSongInteraction] = try await supabase
            .from("UserSongInteraction")
            .select()
            .eq("user_id", value: userId)
            .eq("song_id", value: songId)
            .execute()
            .value

        guard let interaction = interactions.first, interaction.isLiked else {
            return // No interaction or not liked
        }

        // Update interaction
        let updatePayload = UserSongInteractionUpdate(
            is_liked: false,
            is_favourited: interaction.isFavourited, // Preserve is_favourited
            updated_at: Date().iso8601
        )
        try await supabase
            .from("UserSongInteraction")
            .update(updatePayload)
            .eq("interaction_id", value: interaction.interactionId)
            .execute()

        // Update like_count
        let currentSong: SoulfulEscapeSong = try await supabase
            .from("SoulfulEscapeSong")
            .select()
            .eq("song_id", value: songId)
            .single()
            .execute()
            .value
        try await supabase
            .from("SoulfulEscapeSong")
            .update(["like_count": max(0, currentSong.likeCount - 1)])
            .eq("song_id", value: songId)
            .execute()

        likedSongs.removeAll { $0.songId == songId }
    }
    

    
    //Func to add song to favourite
    func addFavoriteSong(songId: UUID) async throws -> FavoriteSong {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        // Verify song exists
        let songExists: [SoulfulEscapeSong] = try await supabase
            .from("SoulfulEscapeSong")
            .select("song_id")
            .eq("song_id", value: songId)
            .execute()
            .value
        guard !songExists.isEmpty else {
            throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Song not found"])
        }

        // Check for existing interaction
        let existingInteractions: [UserSongInteraction] = try await supabase
            .from("UserSongInteraction")
            .select()
            .eq("user_id", value: userId)
            .eq("song_id", value: songId)
            .execute()
            .value

        let favoriteSong: FavoriteSong
        if let interaction = existingInteractions.first {
            // Update existing interaction if not already favorited
            if !interaction.isFavourited {
                let updatePayload = UserSongInteractionUpdate(
                    is_liked: interaction.isLiked, // Preserve is_liked
                    is_favourited: true, // Set to true
                    updated_at: Date().iso8601
                )
                favoriteSong = try await supabase
                    .from("UserSongInteraction")
                    .update(updatePayload)
                    .eq("interaction_id", value: interaction.interactionId)
                    .select("""
                        interaction_id,
                        user_id,
                        song_id,
                        created_at,
                        SoulfulEscapeSong!song_id(
                            song_id,
                            image_name,
                            title,
                            subtitle,
                            duration,
                            category,
                            like_count,
                            file_url,
                            created_at AS song_created_at
                        )
                    """)
                    .single()
                    .execute()
                    .value
            } else {
                // Already favorited, fetch current state
                favoriteSong = try await supabase
                    .from("UserSongInteraction")
                    .select("""
                        interaction_id,
                        user_id,
                        song_id,
                        created_at,
                        SoulfulEscapeSong!song_id(
                            song_id,
                            image_name,
                            title,
                            subtitle,
                            duration,
                            category,
                            like_count,
                            file_url,
                            created_at AS song_created_at
                        )
                    """)
                    .eq("interaction_id", value: interaction.interactionId)
                    .single()
                    .execute()
                    .value
            }

            // Update favouriteSongs array
            if let index = favouriteSongs.firstIndex(where: { $0.id == favoriteSong.id }) {
                favouriteSongs[index] = favoriteSong
            } else {
                favouriteSongs.append(favoriteSong)
            }
        } else {
            // Insert new interaction
            let insertPayload = try UserSongInteractionInsert(
                user_id: userId,
                song_id: songId,
                is_liked: false, // Default to false
                is_favourited: true, // Set to true
                created_at: Date(),
                updated_at: Date()
            )
            favoriteSong = try await supabase
                .from("UserSongInteraction")
                .insert(insertPayload)
                .select("""
                    interaction_id,
                    user_id,
                    song_id,
                    created_at,
                    SoulfulEscapeSong! ping_id(
                        song_id,
                        image_name,
                        title,
                        subtitle,
                        duration,
                        category,
                        like_count,
                        file_url,
                        created_at AS song_created_at
                    )
                """)
                .single()
                .execute()
                .value

            favouriteSongs.append(favoriteSong)
        }

        favouriteSongs.sort { $0.interactionCreatedAt > $1.interactionCreatedAt }
        return favoriteSong
    }

    //Func to remove it from favourite song
    func removeFavoriteSong(songId: UUID) async throws {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        // Check for existing interaction
        let interactions: [UserSongInteraction] = try await supabase
            .from("UserSongInteraction")
            .select()
            .eq("user_id", value: userId)
            .eq("song_id", value: songId)
            .execute()
            .value

        guard let interaction = interactions.first, interaction.isFavourited else {
            return // No interaction or not favorited
        }

        // Update interaction
        let updatePayload = UserSongInteractionUpdate(
            is_liked: interaction.isLiked, // Preserve is_liked
            is_favourited: false, // Set to false
            updated_at: Date().iso8601
        )
        try await supabase
            .from("UserSongInteraction")
            .update(updatePayload)
            .eq("interaction_id", value: interaction.interactionId)
            .execute()

        favouriteSongs.removeAll { $0.songId == songId }
    }
    
    
    
    // Func to create a new playlist
        func createPlaylist(name: String) async throws -> Playlist {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            
            // Create a new playlist record
            let newPlaylist = Playlist(
                id: UUID(),
                userId: userId,
                name: name,
                createdAt: Date()
            )
            
            // Insert the record into the Playlist table and fetch the inserted record
            let insertedPlaylist: Playlist = try await supabase
                .from("Playlist")
                .insert(newPlaylist)
                .select()
                .single()
                .execute()
                .value
            
            // Update the userPlaylists array
            self.userPlaylists.append(insertedPlaylist)
            
            // Sort playlists by created_at for consistency
            self.userPlaylists.sort { $0.createdAt < $1.createdAt }
            
            return insertedPlaylist
        }
    
    
    
    // Func to delete a playlist and its associated songs
        func deletePlaylist(playlistId: UUID) async throws -> Bool {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            
            // Verify playlist exists and belongs to the user
            let playlistExists: [Playlist] = try await supabase
                .from("Playlist")
                .select("playlist_id")
                .eq("playlist_id", value: playlistId)
                .eq("user_id", value: userId)
                .execute()
                .value
            guard !playlistExists.isEmpty else {
                throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Playlist not found or does not belong to user"])
            }
            
            // Delete all associated PlaylistSong records
            try await supabase
                .from("PlaylistSong")
                .delete()
                .eq("playlist_id", value: playlistId)
                .execute()
            
            // Delete the Playlist record
            try await supabase
                .from("Playlist")
                .delete()
                .eq("playlist_id", value: playlistId)
                .execute()
            
            // Update the userPlaylists and userPlaylistSongs arrays
            self.userPlaylists.removeAll { $0.id == playlistId }
            self.userPlaylistSongs.removeAll { $0.playlistId == playlistId }
            
            return true
        }
    
    
    //Func to get all playlist
    func getAllPlaylistName()->[Playlist]{
        return userPlaylists
    }
    
    
    // Func to fetch all songs in a specific playlist
        func fetchSongsInPlaylist(playlistId: UUID) async throws -> [SoulfulEscapeSong] {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            
            // Verify playlist exists and belongs to the user
            let playlistExists: [Playlist] = try await supabase
                .from("Playlist")
                .select("playlist_id")
                .eq("playlist_id", value: playlistId)
                .eq("user_id", value: userId)
                .execute()
                .value
            guard !playlistExists.isEmpty else {
                throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Playlist not found or does not belong to user"])
            }
            
            // Fetch songs in the playlist by joining PlaylistSong with SoulfulEscapeSong
            let songs: [SoulfulEscapeSong] = try await supabase
                .from("PlaylistSong")
                .select("""
                    SoulfulEscapeSong!song_id(
                        song_id,
                        image_name,
                        title,
                        subtitle,
                        duration,
                        category,
                        like_count,
                        file_url,
                        created_at
                    )
                """)
                .eq("playlist_id", value: playlistId)
                .order("created_at", ascending: true, referencedTable: "SoulfulEscapeSong")
                .execute()
                .value
            
            return songs
        }
    
    
    
    // Func to add a song to a playlist
        func addSongToPlaylist(playlistId: UUID, songId: UUID) async throws -> PlaylistSong {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            
            // Verify playlist exists and belongs to the user
            let playlistExists: [Playlist] = try await supabase
                .from("Playlist")
                .select("playlist_id")
                .eq("playlist_id", value: playlistId)
                .eq("user_id", value: userId)
                .execute()
                .value
            guard !playlistExists.isEmpty else {
                throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Playlist not found or does not belong to user"])
            }
            
            // Verify song exists
            let songExists: [SoulfulEscapeSong] = try await supabase
                .from("SoulfulEscapeSong")
                .select("song_id")
                .eq("song_id", value: songId)
                .execute()
                .value
            guard !songExists.isEmpty else {
                throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Song not found"])
            }
            
            // Check if song is already in the playlist
            let existingPlaylistSong: [PlaylistSong] = try await supabase
                .from("PlaylistSong")
                .select()
                .eq("playlist_id", value: playlistId)
                .eq("song_id", value: songId)
                .execute()
                .value
            guard existingPlaylistSong.isEmpty else {
                throw NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Song already exists in playlist"])
            }
            
            // Create a new playlist song record
            let newPlaylistSong = PlaylistSong(
                id: UUID(),
                playlistId: playlistId,
                songId: songId,
                createdAt: Date()
            )
            
            // Insert the record into the PlaylistSong table and fetch the inserted record
            let insertedPlaylistSong: PlaylistSong = try await supabase
                .from("PlaylistSong")
                .insert(newPlaylistSong)
                .select()
                .single()
                .execute()
                .value
            
            // Update the userPlaylistSongs array
            self.userPlaylistSongs.append(insertedPlaylistSong)
            
            // Sort userPlaylistSongs by createdAt for consistency
            self.userPlaylistSongs.sort { $0.createdAt < $1.createdAt }
            
            return insertedPlaylistSong
        }
    
    
    
    // Func to remove a song from a playlist
    func removeSongFromPlaylist(playlistId: UUID, songId: UUID) async throws -> Bool {
            guard let userId = currentUser?.id else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            }
            
            // Verify playlist exists and belongs to the user
            let playlistExists: [Playlist] = try await supabase
                .from("Playlist")
                .select("playlist_id")
                .eq("playlist_id", value: playlistId)
                .eq("user_id", value: userId)
                .execute()
                .value
            guard !playlistExists.isEmpty else {
                throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Playlist not found or does not belong to user"])
            }
            
            // Check if the song exists in the playlist
            let existingPlaylistSong: [PlaylistSong] = try await supabase
                .from("PlaylistSong")
                .select()
                .eq("playlist_id", value: playlistId)
                .eq("song_id", value: songId)
                .execute()
                .value
            guard let playlistSong = existingPlaylistSong.first else {
                throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Song not found in playlist"])
            }
            
            // Delete the record from the PlaylistSong table
            try await supabase
                .from("PlaylistSong")
                .delete()
                .eq("playlist_song_id", value: playlistSong.id)
                .execute()
            
            // Update the userPlaylistSongs array
            self.userPlaylistSongs.removeAll { $0.id == playlistSong.id }
            
            return true
        }
    
    
    
    //MARK: Peace Points Tab Functions
    
    
    
  
    
}



