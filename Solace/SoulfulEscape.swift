import SwiftUI

struct SoulfulEscape: View {
    @State private var searchText = ""
    @State private var selectedMood = "Sad"
    let moods = ["Sad", "Uneasy", "Nervous", "Frustrated", "Hyper", "Furious"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Tunes", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Mood Selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(moods, id: \.self) { mood in
                                Button(action: {
                                    selectedMood = mood
                                }) {
                                    Text(mood)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedMood == mood ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                        .foregroundColor(selectedMood == mood ? .blue : .gray)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Mood Tunes Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Mood Tunes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(["Deep Sleep", "Insomnia Heal", "Deep Thinking"], id: \.self) { tune in
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack(alignment: .bottomTrailing) {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 160, height: 160)
                                            
                                            HStack {
                                                Button(action: {}) {
                                                    Image(systemName: "play.fill")
                                                        .foregroundColor(.white)
                                                        .padding(8)
                                                        .background(Color.blue)
                                                        .clipShape(Circle())
                                                }
                                            }
                                            .padding(8)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(tune)
                                                .font(.headline)
                                            
                                            HStack {
                                                Text(tune == "Deep Sleep" ? "Restorative sleep" : 
                                                     tune == "Insomnia Heal" ? "Cellular healing" : "Calm creativity")
                                                    .foregroundColor(.gray)
                                                Text("•")
                                                    .foregroundColor(.gray)
                                                Text(tune == "Deep Sleep" ? "4 min" :
                                                     tune == "Insomnia Heal" ? "3 min" : "3 min")
                                                    .foregroundColor(.gray)
                                            }
                                            .font(.caption)
                                            
                                            if tune == "Deep Sleep" {
                                                HStack {
                                                    Image(systemName: "flame.fill")
                                                        .foregroundColor(.orange)
                                                    Text("72K")
                                                        .font(.caption)
                                                }
                                            } else if tune == "Insomnia Heal" {
                                                HStack {
                                                    Image(systemName: "flame.fill")
                                                        .foregroundColor(.orange)
                                                    Text("301K")
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 160)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Explore Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Explore")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                            ForEach(["Radiant", "Harmonic Ease", "Elevated Spirit"], id: \.self) { item in
                                HStack(spacing: 16) {
                                    // Image placeholder
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item)
                                            .font(.headline)
                                        Text(item == "Radiant" ? "Postivity" :
                                             item == "Harmonic Ease" ? "Ease" : "Uplift")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                            .padding(8)
                                            .background(Color.gray.opacity(0.1))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Nature Tunes Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Nature Tunes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<4) { _ in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 160, height: 160)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct SoulfulEscape_Previews: PreviewProvider {
    static var previews: some View {
        SoulfulEscape()
    }
}