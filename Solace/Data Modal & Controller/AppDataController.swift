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

    
    
    
    
    //MARK: Function Based on Functionality

    
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
                                duration,
                                category AS mood_category,
                                file_url AS url,
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
                                duration,
                                category AS mood_category,
                                file_url AS url,
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
                let insertPayload = UserSongInteractionInsert(
                    user_id: userId,
                    song_id: songId,
                    is_liked: true,
                    created_at: Date().iso8601,
                    updated_at: Date().iso8601
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
                            duration,
                            category AS mood_category,
                            file_url AS url,
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
                                duration,
                                category AS mood_category,
                                file_url AS url,
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
                                duration,
                                category AS mood_category,
                                file_url AS url,
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
                let insertPayload = UserSongInteractionInsert(
                    user_id: userId,
                    song_id: songId,
                    is_liked: false, // Default to false for is_liked
                    created_at: Date().iso8601,
                    updated_at: Date().iso8601
                )
                favoriteSong = try await supabase
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
                            duration,
                            category AS mood_category,
                            file_url AS url,
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
                updated_at: Date().iso8601
            )
            try await supabase
                .from("UserSongInteraction")
                .update(updatePayload)
                .eq("interaction_id", value: interaction.interactionId)
                .execute()

            favouriteSongs.removeAll { $0.songId == songId }
        }
    
}



