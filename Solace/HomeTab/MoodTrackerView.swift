import SwiftUI

struct MoodTrackerAppView: View {
    @State private var showLogMoodSheet = false
    @State private var currentTime = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header Section
            HStack {
                Text("Hi Andrew Tate")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Stats Section (Inside a Card)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 120)
                
                HStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 80, height: 80)
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading) {
                        if !currentTime.isEmpty {
                            Text("Very Pleasant")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        Text(currentTime.isEmpty ? "Please enter your mood" : currentTime)
                            .font(.caption2)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                         //   .fixedSize(horizontal: true, vertical: false)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Update current time when button is pressed (time only)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a"
                        currentTime = formatter.string(from: Date())
                        
                        showLogMoodSheet.toggle()
                    }) {
                        Text("Log Mood")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showLogMoodSheet) {
                VStack {
                    Text("Log Mood")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
            }
            
            // Calendar Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Monthly Stats")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(1...30, id: \.self) { day in
                            VStack {
                                Text("\(day)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Image(systemName: day % 2 == 0 ? "smiley.fill" : "smiley")
                                    .foregroundColor(day % 2 == 0 ? .yellow : .gray)
                            }
                            .frame(width: 50, height: 70)
                            .background(day % 2 == 0 ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Let's Improve Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Let's Improve")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Image(systemName: "sun.max.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.orange)
                            Text("Stage 1")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("Rise & Shine")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 150, height: 200)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        VStack(alignment: .leading) {
                            Image(systemName: "moon.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.purple)
                            Text("Stage 2")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("Sleep Well")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 150, height: 200)
                        .background(Color.purple.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct MoodTrackerAppView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerAppView()
    }
}
