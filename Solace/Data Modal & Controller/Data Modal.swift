//
//  Data Modal.swift
//  Solace
//
//  Created by Kavyansh Pratap Singh on 05/05/25.
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    let id: UUID
    let firstName: String
    let middleName: String?
    let lastName: String
    let age: Int
    let profession: String
    let email: String
    let dateOfBirth: Date
    let userPoints: Int
    let gender: Gender
    let address: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case age
        case profession
        case email
        case dateOfBirth = "date_of_birth"
        case userPoints = "user_points"
        case gender
        case address
        case createdAt = "created_at"
    }
}

enum Gender : String,Codable{
    case male = "Male"
    case female = "Female"
    case other = "Other"
}


struct Streak: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let streakCount: Int
    let longestStreak: Int
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "streak_id"
        case userId = "user_id"
        case streakCount = "streak_count"
        case longestStreak = "longest_streak"
        case updatedAt = "updated_at"
    }
}

struct UserDailyMoodRecord: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let date: Date
    let moodEmoji: String?
    let moodCategory: MoodCategory?
    let isFeedbackSubmitted: Bool?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "daily_record_id"
        case userId = "user_id"
        case date
        case moodEmoji = "mood_emoji"
        case moodCategory = "mood_category"
        case isFeedbackSubmitted = "is_feedback_submitted"
        case createdAt = "created_at"
    }
}


enum MoodCategory: String, CaseIterable,Codable{
    case veryPleasant = "Very Pleasant"
    case pleasant = "Pleasant"
    case neutral = "Neutral"
    case unpleasant = "Unpleasant"
    case veryUnpleasant = "Very Unpleasant"
}

struct SoulfulEscapeSong: Codable, Equatable, Identifiable {
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    let duration: Double
    let category: MoodCategory
    let likeCount: Int
    let fileUrl: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "song_id"
        case imageName = "image_name"
        case title
        case subtitle
        case duration
        case category
        case likeCount = "like_count"
        case fileUrl = "file_url"
        case createdAt = "created_at"
    }
}

struct LikedSong: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let songId: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "like_id"
        case userId = "user_id"
        case songId = "song_id"
        case createdAt = "created_at"
    }
}

struct FavoriteSong: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let songId: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "favorite_id"
        case userId = "user_id"
        case songId = "song_id"
        case createdAt = "created_at"
    }
}

struct PeacePointTherapy: Codable, Equatable, Identifiable {
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    let videoName: String
    let description: String
    let category: MoodCategory
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "therapy_id"
        case imageName = "image_name"
        case title
        case subtitle
        case videoName = "video_name"
        case description
        case category
        case createdAt = "created_at"
    }
}

struct Quote: Codable, Equatable, Identifiable {
    let id: UUID
    let quoteText: String
    let category: QouteCategory
    let author: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case quoteText = "quote_text"
        case category
        case author
        case createdAt = "created_at"
    }
}

enum QouteCategory : String,Codable{
    case happy = "Happy"
    case motivational = "Motivational"
    case inspirational = "Inspirational"
    case nature = "Nature"
    case life = "Life"
}

struct ChallengeTask: Codable, Equatable {
    let description: String
    let order: Int
}

struct Challenge: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let subtitle: String
    let tasks: [ChallengeTask]
    let totalTasks: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "challenge_id"
        case name
        case imageName = "image_name"
        case subtitle
        case tasks
        case totalTasks = "total_tasks"
        case createdAt = "created_at"
    }
}

struct UserChallenge: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let challengeId: UUID
    let completedTasks: [Int]
    let progress: Float
    let isCompleted: Bool
    let joinedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "user_challenge_id"
        case userId = "user_id"
        case challengeId = "challenge_id"
        case completedTasks = "completed_tasks"
        case progress
        case isCompleted = "is_completed"
        case joinedAt = "joined_at"
    }
}

struct Alarm: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let date: Date
    let enabled: Bool
    let snoozeEnabled: Bool
    let repeatWeekdays: [Int]
    let mediaId: String
    let mediaLabel: String
    let label: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "alarm_id"
        case userId = "user_id"
        case date
        case enabled
        case snoozeEnabled = "snooze_enabled"
        case repeatWeekdays = "repeat_weekdays"
        case mediaId = "media_id"
        case mediaLabel = "media_label"
        case label
        case createdAt = "created_at"
    }
}

struct Playlist: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let name: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "playlist_id"
        case userId = "user_id"
        case name
        case createdAt = "created_at"
    }
}

struct PlaylistSong: Codable, Equatable, Identifiable {
    let id: UUID
    let playlistId: UUID
    let songId: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "playlist_song_id"
        case playlistId = "playlist_id"
        case songId = "song_id"
        case createdAt = "created_at"
    }
}

struct TuneStoreSong: Codable, Equatable, Identifiable {
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    let duration: Double
    let category: String
    let priceValue: Int
    let likeCount: Int
    let audioFileName: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "store_song_id"
        case imageName = "image_name"
        case title
        case subtitle
        case duration
        case category
        case priceValue = "price_value"
        case likeCount = "like_count"
        case audioFileName = "audio_file_name"
        case createdAt = "created_at"
    }
}

struct PurchasedSong: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let songId: UUID
    let purchasedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "purchase_id"
        case userId = "user_id"
        case songId = "song_id"
        case purchasedAt = "purchased_at"
    }
}

//struct CompletedSession: Codable, Equatable, Identifiable {
//    let id: UUID
//    let userId: UUID
//    let songId: UUID?
//    let therapyId: UUID?
//    let completedAt: Date
//
//    enum CodingKeys: String, CodingKey {
//        case id = "session_id"
//        case userId = "user_id"
//        case songId = "song_id"
//        case therapyId = "therapy_id"
//        case completedAt = "completed_at"
//    }
//}

struct CompletedSession: Codable, Equatable, Identifiable {
    let id: UUID
    let userId: UUID
    let songIds: [UUID]?
    let therapyIds: [UUID]?
    let progress: Float
    let completedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "session_id"
        case userId = "user_id"
        case songIds = "song_ids"
        case therapyIds = "therapy_ids"
        case progress
        case completedAt = "completed_at"
    }
}
