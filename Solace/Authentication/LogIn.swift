//
//  LogIn.swift
//  Solace
//
//  Created by Rashika Gupta on 08/05/25.
//


import SwiftUI
import PhotosUI

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

struct LogIn: View {
    @State private var isShowingSignUp = false
    @State private var isShowingForgotPassword = false
    @State private var isShowingVerifyOTP = false
    @State private var isShowingResetPassword = false
    @State private var isAuthenticated = false
    @State private var authError: String?
    @State private var showError = false
    @State private var email: String = ""
    @State private var isLoggedIn: Bool = false
    
    // Load saved login state on app launch
    init() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        _isLoggedIn = State(initialValue: isLoggedIn)
        _isAuthenticated = State(initialValue: isLoggedIn)
        _email = State(initialValue: userEmail)
    }
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView(isAuthenticated: $isAuthenticated, isLoggedIn: $isLoggedIn, email: $email)
            }
           else if isAuthenticated {
                VStack {
                    Text("Welcome!").font(.largeTitle)
                    Button("Logout") {
                        isAuthenticated = false
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    }
                    .padding()
                    .background(Color(hex:"B57281"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else if isShowingResetPassword {
                ResetPasswordView(
                    email: email,
                    isShowingResetPassword: $isShowingResetPassword,
                    isAuthenticated: $isAuthenticated,
                    isLoggedIn: $isLoggedIn,
                    authError: $authError,
                    showError: $showError
                )
            } else if isShowingVerifyOTP {
                VerifyOTPView(
                    isShowingVerifyOTP: $isShowingVerifyOTP,
                    isShowingResetPassword: $isShowingResetPassword,
                    isAuthenticated: $isAuthenticated,
                    isLoggedIn: $isLoggedIn,
                    authError: $authError,
                    showError: $showError,
                    email: email
                )
            } else if isShowingForgotPassword {
                ForgotPasswordView(
                    email: $email,
                    isShowingForgotPassword: $isShowingForgotPassword,
                    isShowingVerifyOTP: $isShowingVerifyOTP,
                    authError: $authError,
                    showError: $showError
                )
            } else if isShowingSignUp {
                SignUpView(isShowingSignUp: $isShowingSignUp, isShowingVerifyOTP: $isShowingVerifyOTP, email: $email)
            } else {
                LoginView(
                    isShowingSignUp: $isShowingSignUp,
                    isShowingForgotPassword: $isShowingForgotPassword,
                    isShowingVerifyOTP: $isShowingVerifyOTP,
                    isAuthenticated: $isAuthenticated,
                    email: $email,
                    isLoggedIn: $isLoggedIn
                )
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authError ?? "Unknown error occurred")
        }
    }
}

struct ForgotPasswordView: View {
    @Binding var email: String
    @Binding var isShowingForgotPassword: Bool
    @Binding var isShowingVerifyOTP: Bool
    @Binding var authError: String?
    @Binding var showError: Bool
    
    var body: some View {
        ZStack {
            Color(hex:"B57281").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height * 0.27)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack(spacing: 25) {
                        Text("Forgot Password")
                            .font(.system(size: 36))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex:"B57281"))
                            .padding(.top, 40)
                        
                        Text("Enter your email to receive a verification code")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            TextField("Email", text: $email)
                                .padding(.vertical, 20)
                                .padding(.leading, 10)
                                .autocapitalization(.none)
                        }
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            Task {
                                do {
                                    // Here you would call Supabase to send OTP
                                    try await SupabaseDataController.shared.sendOTP(email: email)
                                    isShowingVerifyOTP = true
                                    isShowingForgotPassword = false
                                } catch {
                                    authError = error.localizedDescription
                                    showError = true
                                }
                            }
                        }) {
                            Text("Send Verification Code")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(hex:"B57281"))
                                .cornerRadius(30)
                                .padding(.horizontal, 20)
                        }
                        
                        Button("Back to Login") {
                            isShowingForgotPassword = false
                        }
                        .foregroundColor(Color(hex:"B57281"))
                        .padding(.bottom, 30)
                    }
                }
            }
            
            // Top header content
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reset")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your Password")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Image(systemName: "lock.shield.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                }
                
                Spacer()
            }
        }
    }
}

struct ResetPasswordView: View {
    let email: String
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @Binding var isShowingResetPassword: Bool
    @Binding var isAuthenticated: Bool
    @Binding var isLoggedIn: Bool
    @Binding var authError: String?
    @Binding var showError: Bool
    
    var body: some View {
        ZStack {
            Color(hex:"B57281").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height * 0.27)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack(spacing: 25) {
                        Text("Reset Password")
                            .font(.system(size: 36))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex:"B57281"))
                            .padding(.top, 40)
                        
                        Text("Create a new password for your account")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            SecureField("New Password", text: $newPassword)
                                .padding(.vertical, 20)
                                .padding(.leading, 10)
                        }
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            SecureField("Confirm Password", text: $confirmPassword)
                                .padding(.vertical, 20)
                                .padding(.leading, 10)
                        }
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            if newPassword == confirmPassword {
                                Task {
                                    do {
                                        // Here you would call Supabase to reset password
                                        try await SupabaseDataController.shared.resetPassword(email: email, newPasword: newPassword)
                                        
                                        // Auto login with new password
                                        try await SupabaseDataController.shared.signIn(email: email, password: newPassword)
                                        
                                        isLoggedIn = true
                                        isAuthenticated = true
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        UserDefaults.standard.set(email, forKey: "userEmail")
                                    } catch {
                                        authError = error.localizedDescription
                                        showError = true
                                    }
                                }
                            } else {
                                authError = "Passwords do not match"
                                showError = true
                            }
                        }) {
                            Text("Reset Password")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(hex:"B57281"))
                                .cornerRadius(30)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            
            // Top header content
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("New")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Password")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Image(systemName: "key.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                }
                
                Spacer()
            }
        }
    }
}

struct LoginView: View {
    @Binding var isShowingSignUp: Bool
    @Binding var isShowingForgotPassword: Bool
    @Binding var isShowingVerifyOTP: Bool
    @Binding var isAuthenticated: Bool
    @Binding var email: String
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Binding var isLoggedIn :  Bool
  
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }

    var body: some View {
        ZStack {
            // Background
            Color(hex:"B57281")
                .edgesIgnoringSafeArea(.all)
            
            // White rounded overlay
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height * 0.27)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack(spacing: 25) {
                        // Login text
                        Text("Login")
                            .font(.system(size: 36))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex:"B57281"))
                            .padding(.top, 40)
                        
                        VStack(spacing: 22) {
                            // Email field
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                
                                TextField("Email", text: $email)
                                    .padding(.vertical, 20)
                                    .padding(.leading, 10)
                                    .autocapitalization(.none)
                            }
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                            
                            // Password field
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                
                                SecureField("Password", text: $password)
                                    .padding(.vertical, 20)
                                    .padding(.leading, 10)
                            }
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal, 20)
                        
                        // Forgot password
                        HStack {
                            Spacer()
                            Button(action: {
                                isShowingForgotPassword = true
                            }) {
                                Text("Forgot Password")
                                    .foregroundColor(Color(hex: "B57281"))
                            }
                            .padding(.trailing, 20)
                        }
                        
                        // Login button
                        Button(action: {
                            loginUser()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(isFormValid ? Color(hex:"B57281") : Color(hex:"B57281").opacity(0.5))
                                .cornerRadius(30)
                                .padding(.horizontal, 20)
                        }
                        .disabled(!isFormValid)
                        
                        // Or login with
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                                .padding(.leading, 20)
                            
                            Text("Or login with")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                                .padding(.trailing, 20)
                        }
                        .padding(.vertical, 10)
                        
                        // Social login buttons
                        HStack(spacing: 15) {
//
                            // Apple button
                            Button(action: {
                                signInAppleAuth()
                                // Apple login
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                                    
                                    Image(systemName: "apple.logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        
                       // Spacer()
                        
                        // Don't have account
                        HStack(spacing: 5) {
                            Text("Don't have account?")
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                isShowingSignUp = true
                            }) {
                                Text("Sign Up")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hex:"B57281"))
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            
            // Top header content
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello!")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Welcome to solace")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    .padding(.leading, 20)
                    .padding(.top, 60)
        
                Spacer()
                    
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    func signInAppleAuth() {
        let signInApple = AppleAuth()
        signInApple.startSignInWithAppleFlow { result in
            switch result {
            case .failure(let error):
                print("Apple Sign In Error: \(error.localizedDescription)")
            case .success(let appleResult):
                Task {
                    do {
                        try await SupabaseDataController.shared.singnWithApple(
                            idToken: appleResult.idToken,
                            nonce: appleResult.nonce
                        )
                        
                        let userEmail = appleResult.email ?? "apple_user@example.com"
                        
                        // Set authenticated state
                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                           self.isLoggedIn = true
                            
                            // Save login state
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.set(userEmail, forKey: "userEmail")
                        }
                    } catch {
                        print("Supabase Apple Sign In Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
func loginUser() {
        Task {
            do {
                // Attempt to sign in with Supabase
                try await SupabaseDataController.shared.signIn(
                    email: email,
                    password: password
                )
                
                // If login is successful, navigate to the home page
                DispatchQueue.main.async {
                    isAuthenticated = true
                    isLoggedIn = true
                    
                    // Save login state
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                }
            } catch {
                // If login fails, show an error alert
                DispatchQueue.main.async {
                    alertMessage = "Invalid credentials. Please try again."
                    showAlert = true
                }
            }
        }
    }
}

struct SignUpView: View {
    @Binding var isShowingSignUp: Bool
    @Binding var isShowingVerifyOTP: Bool
    @Binding var email: String
    @State private var firstName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var profession = ""
    @State private var age : Int = 0
    @State private var dateOfBirth = Date()
    @State private var gender = "Male"
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userPoint = 0
    @State private var isLoading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    var ageStringBinding: Binding<String> {
        Binding<String>(
            get: { String(age) },
            set: { age = Int($0) ?? 0 }
        )
    }
    
    var genderOptions = ["Male", "Female", "Other"]
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !profession.isEmpty &&
        !email.isEmpty && email.contains("@") &&
        !address.isEmpty &&
        !phoneNumber.isEmpty && phoneNumber.count >= 10 &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 8 &&
        password.contains(where: { $0.isUppercase }) &&
        password.contains(where: { $0.isLowercase }) &&
        password.contains(where: { $0.isNumber }) &&
        password.contains(where: { !$0.isLetter && !$0.isNumber && !$0.isWhitespace })
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with back button
                    HStack {
                        Button(action: {
                            isShowingSignUp = false
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color(hex:"B57281"))
                                Text("Back to login")
                                    .foregroundColor(Color(hex:"B57281"))
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex:"B57281"))
                        .padding(.bottom, 20)
                    
                    // Form fields
                    VStack(spacing: 20) {
                        // First Name
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            TextField("First Name", text: $firstName)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Middle Name
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            TextField("Middle Name (Optional)", text: $middleName)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Last Name
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            TextField("Last Name", text: $lastName)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        HStack {
                               Image(systemName: "character")
                                   .foregroundColor(.gray)
                            TextField("Age", text: ageStringBinding)
                                .keyboardType(.numberPad)
                           }
                           .padding()
                           .background(Color.white)
                           .cornerRadius(30)
                           .shadow(color: Color.black.opacity(0.05), radius: 5)
                        // Profession
                        HStack {
                            Image(systemName: "briefcase")
                                .foregroundColor(.gray)
                            TextField("Profession", text: $profession)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Email
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email", text: $email)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        .autocapitalization(.none)
                        // Birth Date
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Gender
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Picker("", selection: $gender) {
                                ForEach(genderOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Address
                        HStack {
                            Image(systemName: "house")
                                .foregroundColor(.gray)
                            TextField("Address", text: $address)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Phone Number (Added after address)
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.gray)
                            TextField("Phone Number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .onChange(of: phoneNumber) { newValue in
                                    phoneNumber = String(newValue.filter { "0123456789".contains($0) })
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Password
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                SecureField("Password", text: $password)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            
                            // Password requirements
                            VStack(alignment: .leading, spacing: 5) {
                                passwordRequirement(text: "At least 8 characters", isValid: password.count >= 8)
                                passwordRequirement(text: "At least one uppercase letter", isValid: password.contains(where: { $0.isUppercase }))
                                passwordRequirement(text: "At least one lowercase letter", isValid: password.contains(where: { $0.isLowercase }))
                                passwordRequirement(text: "At least one number", isValid: password.contains(where: { $0.isNumber }))
                                passwordRequirement(text: "At least one special character", isValid: password.contains(where: { !$0.isLetter && !$0.isNumber && !$0.isWhitespace }))
                            }
                            .padding(.leading)
                        }
                        
                        // Confirm Password
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Sign Up button
                        Button(action: {
                            registerUser()
                            Task{
                                try await SupabaseDataController.shared.resendOTP(email: "")
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex:"B57281"))
                                    .cornerRadius(30)
                            } else {
                                Text("Sign Up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isFormValid ? Color(hex:"B57281") : Color(hex:"B57281").opacity(0.5))
                                    .cornerRadius(30)
                            }
                        }
                        .padding(.top, 10)
                        .disabled(!isFormValid || isLoading)
                    }
                    .padding(.horizontal, 25)
                }
            }
            
            // Toast message
            if showToast {
                VStack {
                    Spacer()
                    
                    Text(toastMessage)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showToast)
                .zIndex(1)
            }
        }
    }
    
    func registerUser() {
        isLoading = true
        let user = UserData(
            first_name: firstName,
            middle_name: middleName,
            last_name: lastName,
            profession: profession,
            age: age,
            email: email,
            date_of_birth: dateOfBirth,
            gender: gender,
            address: address,
            phone_number: phoneNumber,
            password: password, userPoints: userPoint
        )
        
        Task {
            do {
                try await SupabaseDataController.shared.signUp(user: user)
                print("User signed up successfully!")
                
                // Update email in parent view
                self.email = email
                
                DispatchQueue.main.async {
                    isShowingSignUp = false
                    isShowingVerifyOTP = true
                }
                
                // First sign up user with Supabase Auth
                try await SupabaseDataController.shared.insertUserData(user: user)
                print("User inserted successfully!")
            }
                
                catch {
                            print("Error: \(error.localizedDescription)")
                        }
            }
        }
    }
    //
func passwordRequirement(text: String, isValid: Bool) -> some View {
    HStack {
        Circle()
            .stroke(isValid ? Color.green : Color.gray, lineWidth: 1)
            .frame(width: 15, height: 15)
        
        Text(text)
            .font(.caption)
            .foregroundColor(.gray)
    }
}

struct VerifyOTPView: View {
    @Binding var isShowingVerifyOTP: Bool
    @Binding var isShowingResetPassword: Bool
    @Binding var isAuthenticated: Bool
    @Binding var isLoggedIn: Bool
    @Binding var authError: String?
    @Binding var showError: Bool
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var isLoading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var remainingTime = 60
    
    var email: String
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var isOTPValid: Bool {
        !otpFields.contains(where: { $0.isEmpty })
    }
    
    var body: some View {
        ZStack {
            Color(hex: "B57281")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: {
                        isShowingVerifyOTP = false
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Back")
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                Spacer()
                
                // White Card
                VStack(spacing: 25) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(hex: "B57281"))
                        .padding(.top, 40)
                    
                    Text("Verification")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "B57281"))
                    
                    Text("Enter the 6-digit code sent to your email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // OTP Fields
                    HStack(spacing: 15) {
                        ForEach(0..<6, id: \.self) { index in
                            TextField("", text: $otpFields[index])
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: index)
                                .onChange(of: otpFields[index]) { newValue in
                                    if newValue.count > 1 {
                                        otpFields[index] = String(newValue.prefix(1))
                                    }
                                    if newValue.count == 1 && index < 5 {
                                        focusedField = index + 1
                                    }
                                }
                                .multilineTextAlignment(.center)
                                .frame(width: 45, height: 45)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(focusedField == index ? Color(hex: "B57281") : Color.gray.opacity(0.3), lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                    }
                    .padding(.vertical, 20)
                    
                    // Verify Button
                    Button(action: {
                        verificationFromOTP()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "B57281"))
                                .cornerRadius(30)
                        } else {
                            Text("Verify")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isOTPValid ? Color(hex: "B57281") : Color(hex: "FA415F").opacity(0.5))
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 20)
                    .disabled(!isOTPValid || isLoading)
                    
                    // Timer/Resend Button
                    VStack {
                        if remainingTime > 0 {
                            Text("Resend code in \(remainingTime)s")
                                .foregroundColor(.gray)
                                .onReceive(timer) { _ in
                                    if remainingTime > 0 {
                                        remainingTime -= 1
                                    }
                                }
                        } else {
                            Button(action: {
                                resendOTP()
                            }) {
                                Text("Resend Code")
                                    .foregroundColor(Color(hex: "B57281"))
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            
            // Toast Message
            if showToast {
                VStack {
                    Spacer()
                    
                    Text(toastMessage)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showToast)
                .zIndex(1)
            }
        }
    }
    
    func verificationFromOTP() {
        guard !email.isEmpty else {
            authError = "Email is missing"
            showError = true
            return
        }
        
        isLoading = true
        let otpCode = otpFields.joined()
        
        Task {
            do {
                // Verify OTP with the proper email
                try await SupabaseDataController.shared.verifyOTP(
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    token: otpCode
                )
                
                print("OTP verification successful for email: \(email)")
                
                DispatchQueue.main.async {
                    isLoading = false
                    isShowingVerifyOTP = false
                    isShowingResetPassword = true
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    authError = error.localizedDescription
                    showError = true
                    print("OTP verification failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func resendOTP() {
        Task {
            do {
                try await SupabaseDataController.shared.sendOTP(email: email)
                remainingTime = 60
                toastMessage = "New OTP sent to your email"
                showToast = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showToast = false
                }
            } catch {
                DispatchQueue.main.async {
                    authError = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

struct HomeView: View {
    @Binding var isAuthenticated: Bool
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @State private var showProfileView = false
    @State private var userName: String = "User"
    @State private var profileImage: Image?
    @State private var refreshProfileTrigger = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "E78996").opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome back,")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text(userName)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "A94064"))
                        }
                        
                        Spacer()
                        
                        // Profile Button
                        Button(action: {
                            showProfileView = true
                        }) {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color(hex: "B57281"), lineWidth: 2))
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(hex: "B57281"))
                            }
                        }
                    }
                    .padding()
                    
                    // Content of home screen
                    Spacer()
                    
                    Text("Welcome to the App")
                        .font(.title)
                        .foregroundColor(Color(hex: "B57281"))
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    // Extract username from email
                    if !email.isEmpty {
                        if let username = email.split(separator: "@").first {
                            userName = username.capitalized
                        }
                    }
                    
                    // Load profile image
                    loadProfileImage()
                }
                .onChange(of: refreshProfileTrigger) { _ in
                    loadProfileImage()
                }
            }
            .navigationDestination(isPresented: $showProfileView) {
                ProfileView(isAuthenticated: $isAuthenticated, isLoggedIn: $isLoggedIn, email: $email, refreshHomeView: $refreshProfileTrigger)
            }
        }
    }
    
    private func loadProfileImage() {
        if let imageKey = createUserSpecificKey(for: "profileImage") {
            if let imageData = UserDefaults.standard.data(forKey: imageKey) {
                // Convert the data to an image
                #if canImport(UIKit)
                if let uiImage = UIImage(data: imageData) {
                    profileImage = Image(uiImage: uiImage)
                }
                #elseif canImport(AppKit)
                if let nsImage = NSImage(data: imageData) {
                    profileImage = Image(nsImage: nsImage)
                }
                #endif
            }
        }
    }
    
    private func createUserSpecificKey(for key: String) -> String? {
        if !email.isEmpty {
            return "\(email)_\(key)"
        }
        return nil
    }
}

struct ProfileView: View {
    @Binding var isAuthenticated: Bool
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @Binding var refreshHomeView: Bool
    @Environment(\.dismiss) private var dismiss
    
    // User profile data
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var address: String = ""
    @State private var phoneNumber: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isEditMode = false
    @State private var profileImage: Image?
    @State private var inputImage: Data?
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            Color(hex: "A94064").opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color(hex: "B57281"))
                                .imageScale(.large)
                        }
                        
                        Spacer()
                        
                        Text("My Profile")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "B57281"))
                        
                        Spacer()
                        
                        Button(action: {
                            isEditMode.toggle()
                            if !isEditMode {
                                saveProfile()
                            }
                        }) {
                            Text(isEditMode ? "Save" : "Edit")
                                .foregroundColor(Color(hex: "B57281"))
                                .fontWeight(.medium)
                        }
                    }
                    .padding()
                    
                    // Profile Image
                    ZStack {
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 5)
                        } else {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.black.opacity(0.1), radius: 5)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(25)
                                        .foregroundColor(Color(hex: "B57281"))
                                )
                        }
                        
                        if isEditMode {
                            PhotosPicker(selection: $photoItem, matching: .images) {
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "B57281"))
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .offset(x: 30, y: 30)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 25) {
                        // Profile Information Fields
                        ProfileFieldView(
                            title: "Email",
                            value: email,
                            iconName: "envelope.fill",
                            isEditable: false
                        )
                        
                        ProfileEditableFieldView(
                            title: "First Name",
                            value: $firstName,
                            iconName: "person.fill",
                            isEditMode: isEditMode
                        )
                        
                        ProfileEditableFieldView(
                            title: "Last Name",
                            value: $lastName,
                            iconName: "person.fill",
                            isEditMode: isEditMode
                        )
                        
                        ProfileEditableFieldView(
                            title: "Address",
                            value: $address,
                            iconName: "house.fill",
                            isEditMode: isEditMode
                        )
                        
                        ProfileEditableFieldView(
                            title: "Phone Number",
                            value: $phoneNumber,
                            iconName: "phone.fill",
                            isEditMode: isEditMode
                        )
                        
                        // Logout Button
                        Button(action: {
                            // Clear user defaults
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            UserDefaults.standard.removeObject(forKey: "userEmail")
                            
                            // Update state
                            isAuthenticated = false
                            isLoggedIn = false
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square.fill")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                                
                                Text("Logout")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "B57281"))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Profile Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadUserProfile()
            loadProfileImage()
        }
        .onDisappear {
            // Toggle refresh trigger when view disappears
            refreshHomeView.toggle()
        }
        .onChange(of: photoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    inputImage = data
                    loadImage()
                }
            }
        }
    }
    
    private func loadUserProfile() {
        // Try to load saved profile data first
        if let userKey = createUserSpecificKey(for: "userData") {
            if let userData = UserDefaults.standard.dictionary(forKey: userKey) as? [String: String] {
                firstName = userData["firstName"] ?? ""
                lastName = userData["lastName"] ?? ""
                address = userData["address"] ?? ""
                phoneNumber = userData["phoneNumber"] ?? ""
                return
            }
        }
        
        // Fallback to generating from email if no saved data
        if !email.isEmpty {
            if let username = email.split(separator: "@").first {
                firstName = String(username).capitalized
                lastName = ""
                address = "Your Address"
                phoneNumber = "1234567890"
            }
        }
    }
    
    private func loadProfileImage() {
        if let imageKey = createUserSpecificKey(for: "profileImage") {
            if let imageData = UserDefaults.standard.data(forKey: imageKey) {
                inputImage = imageData
                loadImage()
            }
        }
    }
    
    private func saveProfileImage() {
        if let inputImage = inputImage {
            if let imageKey = createUserSpecificKey(for: "profileImage") {
                UserDefaults.standard.set(inputImage, forKey: imageKey)
            }
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        
        #if canImport(UIKit)
        if let uiImage = UIImage(data: inputImage) {
            profileImage = Image(uiImage: uiImage)
        }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: inputImage) {
            profileImage = Image(nsImage: nsImage)
        }
        #endif
    }
    
    private func saveProfile() {
        // Save the profile image
        saveProfileImage()
        
        // Here you would save profile data to your database
        // For this demo, we'll just save to UserDefaults
        if let userKey = createUserSpecificKey(for: "userData") {
            let userData: [String: String] = [
                "firstName": firstName,
                "lastName": lastName,
                "address": address,
                "phoneNumber": phoneNumber
            ]
            UserDefaults.standard.set(userData, forKey: userKey)
        }
        
        // Show success message
        alertMessage = "Profile updated successfully!"
        showAlert = true
        
        // Toggle the refresh trigger for the home view
        refreshHomeView.toggle()
    }
    
    private func createUserSpecificKey(for key: String) -> String? {
        if !email.isEmpty {
            return "\(email)_\(key)"
        }
        return nil
    }
}

// Reusable view for non-editable profile field
struct ProfileFieldView: View {
    let title: String
    let value: String
    let iconName: String
    let isEditable: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .foregroundColor(Color(hex: "B57281"))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
            
            if isEditable {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Reusable view for editable profile field
struct ProfileEditableFieldView: View {
    let title: String
    @Binding var value: String
    let iconName: String
    let isEditMode: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .foregroundColor(Color(hex: "B57281"))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if isEditMode {
                    TextField("Enter \(title)", text: $value)
                        .font(.body)
                } else {
                    Text(value)
                        .font(.body)
                }
            }
            
            Spacer()
            
            if isEditMode {
                Image(systemName: "pencil")
                    .foregroundColor(Color(hex: "B57281"))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Helper extension for rounded corners
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LogIn()
}
