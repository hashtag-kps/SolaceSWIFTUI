//
//  SupabaseAuth.swift
//  Authentication
//
//  Created by Rashika Gupta on 26/04/25.


import Foundation
import Supabase
import UIKit
class SupabaseDataController: ObservableObject{
    
    static let shared = SupabaseDataController()
    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://okpogigxwadkqbebrozl.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9rcG9naWd4d2Fka3FiZWJyb3psIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAzNzYzMzQsImV4cCI6MjA1NTk1MjMzNH0.6QNR3dAJ1bMiw0Y2D7SydcDgH91EBcr0U6OjzcnNGFI"
    )
    
    private init() {}
    
    func signUp(user: UserData) async throws {
        let authResponse = try await supabase.auth.signUp(
            email: user.email,
            password: user.password
        )
        print("Signup response:", authResponse)
    }
    
    func insertUserData(user: UserData) async throws {
        try await supabase
            .from("User")
            .insert(user)
            .execute()
        print("User data inserted")
    }
    
    func verifyOTP(email: String, token: String) async throws {
        try await supabase.auth.verifyOTP(
            email: email,
            token: token,
            type: .email
        )
        print("OTP verified")
    }
    
    func resendOTP(email: String) async throws {
        try await supabase.auth.resend(
            email: email, type: .emailChange
        )
        print("OTP resent")
    }
    
    func sendOTP(email: String) async throws {
        try await supabase.auth.signInWithOTP(email: email)
        print("Otp sent")
    }
    
    func signIn(email: String, password: String) async throws {
        try await supabase.auth.signIn(
            email: email,
            password: password
        )
        print("Signed in")
        
    }
    func singnWithApple(idToken: String, nonce: String) async throws {
        try await supabase.auth.signInWithIdToken(credentials: .init(provider: .apple,idToken: idToken,nonce: nonce))
    }
    func resetPassword(email: String, newPasword: String) async throws {
       try await supabase.auth.resetPasswordForEmail(email)
        print("Password reset email sent")
    }
    
}
