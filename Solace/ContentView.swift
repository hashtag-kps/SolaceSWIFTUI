import SwiftUI
//geo
struct ContentView: View {
    @State private var userName = "Jessica G. Anderson"
    @State private var currentMood = "Neutral" // Add this state variable
    @State private var selectedMood: String?
    @State private var isAnimating = false
    @State private var selectedTab = 0
    
    private func getMoodColor(_ mood: String) -> Color {
        switch mood {
        case "Very Happy":
            return Color(red: 0.47, green: 0.62, blue: 0.35) // Light green
        case "Happy":
            return Color(red: 0.98, green: 0.82, blue: 0.45) // Light yellow
        case "Neutral":
            return Color(red: 0.67, green: 0.55, blue: 0.47) // Brown
        case "Sad":
            return Color(red: 0.95, green: 0.65, blue: 0.45) // Light orange
        case "Very Sad":
            return Color(red: 0.67, green: 0.61, blue: 0.85) // Light purple
        default:
            return .gray
        }
    }
    private func getMoodFeatureColor(_ mood: String) -> Color {
        switch mood {
        case "Very Happy":
            return Color(red: 0.27, green: 0.42, blue: 0.15) // Dark green
        case "Happy":
            return Color(red: 0.55, green: 0.42, blue: 0.15) // Dark yellow
        case "Neutral":
            return Color(red: 0.47, green: 0.35, blue: 0.27) // Dark brown
        case "Sad":
            return Color(red: 0.55, green: 0.25, blue: 0.15) // Dark orange
        case "Very Sad":
            return Color(red: 0.27, green: 0.21, blue: 0.55) // Dark purple
        default:
            return .gray
        }
    }
    @State private var selectedMoodIndex = 2 // Default to Neutral
    let moods = ["Very Happy", "Happy", "Neutral", "Sad", "Very Sad"]
    let moodEmojis = ["😊", "🙂", "😐", "🙁", "😢"]
    @State private var isLoggingMood = false
    @State private var likedSongs: Set<String> = []
    @State private var favoriteSongs: Set<String> = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Good morning")
                                    .foregroundColor(.gray)
                                Text(userName)
                                    .font(.title2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.gray)
                        }
                        
                        // Mood Section
                        VStack(alignment: .center, spacing: 24) {
                            Text("How do you feel today?")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Single Mood Card
                            VStack(spacing: 16) {
                                Text("Mood")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                VStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.95, green: 0.97, blue: 1.0))
                                            .frame(width: 200, height: 200)
                                        
                                        getMoodEmoji(currentMood) // New function to get mood emoji
                                    }
                                    
                                    Button(action: {
                                        isLoggingMood = true
                                    }) {
                                        Text("Log")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .frame(width: 120, height: 40)
                                            .background(Color.blue)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        
                        // Session Progress
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deeply Relaxing\nBody & Bind")
                                .font(.title3)
                            Text("18/20 Sessions completed")
                                .foregroundColor(.gray)
                            Text("80%")
                                .font(.system(size: 40, weight: .bold))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(LinearGradient(colors: [.pink.opacity(0.2), .purple.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        // Recommendations
                        Text("Recommended for you")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(["Peaceful Glow", "Joyful Calm", "Blissful Focus"], id: \.self) { song in
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack(alignment: .bottomTrailing) {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 160, height: 160)
                                            
                                            // Play button
                                            Button(action: {}) {
                                                Image(systemName: "play.fill")
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                                    .background(Color.blue)
                                                    .clipShape(Circle())
                                            }
                                            .padding(8)
                                            
                                            // Like and Favorite buttons at top
                                            VStack {
                                                HStack(spacing: 8) {
                                                    Button(action: {
                                                        if likedSongs.contains(song) {
                                                            likedSongs.remove(song)
                                                        } else {
                                                            likedSongs.insert(song)
                                                        }
                                                    }) {
                                                        Image(systemName: likedSongs.contains(song) ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                            .foregroundColor(.white)
                                                            .padding(8)
                                                            .background(Color.gray.opacity(0.5))
                                                            .clipShape(Circle())
                                                    }
                                                    
                                                    Button(action: {
                                                        if favoriteSongs.contains(song) {
                                                            favoriteSongs.remove(song)
                                                        } else {
                                                            favoriteSongs.insert(song)
                                                        }
                                                    }) {
                                                        Image(systemName: favoriteSongs.contains(song) ? "heart.fill" : "heart")
                                                            .foregroundColor(.white)
                                                            .padding(8)
                                                            .background(Color.gray.opacity(0.5))
                                                            .clipShape(Circle())
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .padding(8)
                                        }
                                        
                                        Text(song)
                                            .font(.headline)
                                        
                                        HStack {
                                            Text(song == "Peaceful Glow" ? "Calm Alertness" :
                                                 song == "Joyful Calm" ? "Mindful Focus" : "Blissful State")
                                                .foregroundColor(.gray)
                                            Text("•")
                                                .foregroundColor(.gray)
                                            Text(song == "Peaceful Glow" ? "3 min" :
                                                 song == "Joyful Calm" ? "4 min" : "5 min")
                                                .foregroundColor(.gray)
                                        }
                                        .font(.caption)
                                        
                                        if song == "Peaceful Glow" {
                                            HStack {
                                                Image(systemName: "flame.fill")
                                                    .foregroundColor(.orange)
                                                Text("7.2K")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .frame(width: 160)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }
            .tag(0)
            
            SoulfulEscape()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("Soulful Escapes")
                    }
                }
                .tag(1)
            
            Text("Peace Points")
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.3x3.fill")
                        Text("Peace Points")
                    }
                }
                .tag(2)
        }
        .accentColor(Color.blue)
        .sheet(isPresented: $isLoggingMood) {
            LogMoodView(isPresented: $isLoggingMood, selectedMood: $currentMood) // Pass the binding
        }
    }
    
    // Add this function to get mood emoji
    private func getMoodEmoji(_ mood: String) -> some View {
        VStack(spacing: 40) {
            ZStack {
                // Background circle with mood-specific color
                Circle()
                    .fill(getInnerCircleColor(mood))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Circle()
                            .stroke(getMoodColor(mood).opacity(0.3), lineWidth: 2)
                    )
                
                VStack(spacing: 40) {
                    // Eyes
                    HStack(spacing: 40) {
                        switch mood {
                        case "Very Unpleasant":
                            ForEach(0..<2) { _ in
                                Image(systemName: "multiply")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 12, height: 24)
                            }
                        default:
                            ForEach(0..<2) { _ in
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                    
                    // Mouth
                    switch mood {
                    case "Very Pleasant", "Pleasant":
                        Path { path in
                            path.move(to: CGPoint(x: -35, y: 0))
                            path.addQuadCurve(
                                to: CGPoint(x: 40, y: 0),
                                control: CGPoint(x: 0, y: 40)
                            )
                        }
                        .stroke(Color.black, lineWidth: 8)
                        .frame(width: 8, height: 25)
                    case "Neutral":
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 60, height: 8)
                    case "Unpleasant", "Very Unpleasant":
                        Path { path in
                            path.move(to: CGPoint(x: -35, y: 0))
                            path.addQuadCurve(
                                to: CGPoint(x: 40, y: 0),
                                control: CGPoint(x: 0, y: -40)
                            )
                        }
                        .stroke(Color.black, lineWidth: 8)
                        .frame(width: 8, height: 25)
                    default:
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 60, height: 8)
                    }
                }
            }
        }
    }

    private func getInnerCircleColor(_ mood: String) -> Color {
        switch mood {
        case "Very Pleasant":
            return Color(red: 131/255, green: 153/255, blue: 80/255) // #839950
        case "Pleasant":
            return Color.yellow // Darker yellow for inner circle
        case "Neutral":
            return Color(red: 0.67, green: 0.55, blue: 0.47) // Brown
        case "Unpleasant":
            return Color(red: 0.95, green: 0.65, blue: 0.45) // Light orange
        case "Very Unpleasant":
            return Color(red: 134/255, green: 110/255, blue: 233/255) // #866EE9
        default:
            return Color.white.opacity(0.2) // Default light color for other moods
        }
    }
}

// Modify LogMoodView to accept binding
struct LogMoodView: View {
    @Binding var isPresented: Bool
    @Binding var selectedMood: String
    @State private var selectedMoodIndex = 2
    @State private var isAnimating = false
    @State private var sliderOffset: CGFloat = 0
    @State private var isButtonPressed = false
    let moods = ["Very Pleasant", "Pleasant", "Neutral", "Unpleasant", "Very Unpleasant"]
    
    private func getMoodColor(_ mood: String) -> Color {
        switch mood {
        case "Very Pleasant":
            return Color(red: 131/255, green: 153/255, blue: 80/255) // #839950
        case "Pleasant":
            return Color.yellow.opacity(0.3) // Lighter yellow for background
        case "Neutral":
            return Color(red: 0.67, green: 0.55, blue: 0.47) // Brown
        case "Unpleasant":
            return Color(red: 0.95, green: 0.65, blue: 0.45) // Light orange
        case "Very Unpleasant":
            return Color(red: 134/255, green: 110/255, blue: 233/255).opacity(0.3) // #866EE9
        default:
            return Color(red: 0.67, green: 0.55, blue: 0.47)
        }
    }
    
    private func getInnerCircleColor(_ mood: String) -> Color {
        switch mood {
        case "Pleasant":
            return Color.yellow // Darker yellow for inner circle
        case "Very Unpleasant":
            return Color(red: 134/255, green: 110/255, blue: 233/255) // #866EE9
        default:
            return Color.white.opacity(0.2) // Default light color for other moods
        }
    }
    
    private func getMoodFace(_ mood: String) -> some View {
        VStack(spacing: 40) {
            // Eyes
            HStack(spacing: 40) {
                switch mood {
                case "Very Unpleasant":
                    ForEach(0..<2) { _ in
                        Image(systemName: "multiply")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 12, height: 24)
                    }
                default:
                    ForEach(0..<2) { _ in
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            
            // Mouth
            switch mood {
            case "Very Pleasant", "Pleasant":
                Path { path in
                    path.move(to: CGPoint(x: -35, y: 0))
                    path.addQuadCurve(
                        to: CGPoint(x: 40, y: 0),
                        control: CGPoint(x: 0, y: 40)
                    )
                }
                .stroke(Color.black, lineWidth: 8)
                .frame(width: 8, height: 25)
            case "Neutral":
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 60, height: 8)
            case "Unpleasant", "Very Unpleasant":
                Path { path in
                    path.move(to: CGPoint(x: -35, y: 0))
                    path.addQuadCurve(
                        to: CGPoint(x: 40, y: 0),
                        control: CGPoint(x: 0, y: -40)
                    )
                }
                .stroke(Color.black, lineWidth: 8)
                .frame(width: 8, height: 25)
            default:
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 60, height: 8)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color with smooth transition
                getMoodColor(moods[selectedMoodIndex])
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.3), value: selectedMoodIndex)
                
                VStack(spacing: 20) {
                    Text("Hey,Kelly")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimating)
                    
                    Text("How are you feeling this day?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isAnimating)
                    
                    VStack(spacing: 30) {
                        // Custom mood face with animation
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(getInnerCircleColor(moods[selectedMoodIndex]))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Circle()
                                            .stroke(getMoodColor(moods[selectedMoodIndex]).opacity(0.3), lineWidth: 2)
                                    )
                                    .scaleEffect(isAnimating ? 1 : 0.5)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isAnimating)
                                
                                getMoodFace(moods[selectedMoodIndex])
                                    .opacity(isAnimating ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.3).delay(0.3), value: selectedMoodIndex)
                            }
                            Text(moods[selectedMoodIndex])
                                .font(.title3)
                                .transition(.opacity)
                                .animation(.easeInOut, value: selectedMoodIndex)
                        }
                        .padding(.top, 40)
                        
                        // Slider section
                        VStack(spacing: 8) {
                            Slider(value: .init(get: {
                                Double(selectedMoodIndex)
                            }, set: { newValue in
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation {
                                    selectedMoodIndex = Int(newValue.rounded())
                                }
                            }), in: 0...4, step: 1)
                            .padding(.horizontal)
                            .tint(.blue)
                            
                            // Mood indicators
                            HStack {
                                ForEach(moods, id: \.self) { mood in
                                    Text("•")
                                        .font(.title2)
                                        .foregroundColor(mood == moods[selectedMoodIndex] ? .blue : .gray)
                                        .animation(.easeInOut, value: selectedMoodIndex)
                                }
                            }
                        }
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isAnimating)
                        
                        // Set Mood Button
                        Button(action: {
                            isButtonPressed = true
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            withAnimation {
                                selectedMood = moods[selectedMoodIndex]
                                isPresented = false
                            }
                        }) {
                            Text("Set Mood")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    Color.white
                                        .opacity(0.9)
                                        .shadow(radius: 5)
                                )
                                .cornerRadius(25)
                                .scaleEffect(isButtonPressed ? 0.95 : 1)
                        }
                        .padding(.horizontal)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isAnimating)
                    }
                }
            }
            .navigationBarItems(trailing: Button("Cancel") {
                withAnimation {
                    isPresented = false
                }
            })
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
            isButtonPressed = false
        }
    }
}


#Preview{
    ContentView()
}
