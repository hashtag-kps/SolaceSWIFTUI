//
//  AppleAuth.swift
//  Authentication
//
//  Created by Rashika Gupta on 29/04/25.
//

import Foundation
import CryptoKit
import AuthenticationServices
import SwiftUI
import UIKit
import Supabase

struct AppleUser {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    let idToken: String
}

class AppleAuth: NSObject, ASAuthorizationControllerDelegate {
    private var currentNonce: String?
    private var completionHandler: ((Result<AppleSignInResult, Error>) -> Void)?
    
    // Used for Sign in with Apple flow
    func startSignInWithAppleFlow(completion: @escaping (Result<AppleSignInResult, Error>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // Called when Apple authentication completes
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let idTokenData = appleIDCredential.identityToken,
              let idToken = String(data: idTokenData, encoding: .utf8) else {
            completionHandler?(.failure(AppleSignInError.credentialError))
            return
        }
        
        // Create AppleSignInResult with necessary information
        let result = AppleSignInResult(
            idToken: idToken,
            nonce: nonce,
            userId: appleIDCredential.user,
            fullName: appleIDCredential.fullName,
            email: appleIDCredential.email
        )
        
        // Call Supabase to complete Apple sign-in
        Task {
            do {
                try await SupabaseDataController.shared.singnWithApple(idToken: idToken, nonce: nonce)
                completionHandler?(.success(result))
            } catch {
                completionHandler?(.failure(error))
            }
        }
    }
    
    // Called when Apple authentication fails
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
    }
    
    // MARK: - Helpers
    
    // Generate a random nonce string
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // Hash a string using SHA256
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// Result of Apple Sign in
struct AppleSignInResult {
    let idToken: String
    let nonce: String
    let userId: String
    let fullName: PersonNameComponents?
    let email: String?
}

// Errors that can occur during Apple Sign in
enum AppleSignInError: Error {
    case credentialError
    case tokenError
    case userCancelled
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

