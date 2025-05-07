import SwiftUI

struct MoodTrackerAppView: View {
    @State private var showLogMoodSheet = false
    @State private var showFullCalendarView = false
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
                HStack {
                    Text("Monthly Stats")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        showFullCalendarView.toggle()
                    }) {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // Get current day of month
                        let currentDay = Calendar.current.component(.day, from: Date())
                        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30
                        
                        // Only show current day and future days
                        ForEach(currentDay...daysInMonth, id: \.self) { day in
                            let isCurrentDay = day == currentDay
                            
                            // Create the date and get day name outside of the view hierarchy
                            let dayName: String = {
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month], from: Date())
                                dateComponents.day = day
                                if let date = calendar.date(from: dateComponents) {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "E"
                                    return formatter.string(from: date)
                                }
                                return ""
                            }()
                            
                            VStack {
                                Text(dayName)
                                    .font(.caption)
                                    .foregroundColor(isCurrentDay ? .white : .black)
                                
                                Text("\(day)")
                                    .font(.subheadline)
                                    .foregroundColor(isCurrentDay ? .white : .black)
                                
                                // Replace emoji with custom mood images
                                if day % 5 == 1 {
                                    Image("very unpleasant")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } else if day % 5 == 2 {
                                    Image("unpleasant")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } else if day % 5 == 3 {
                                    Image("neutral")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } else if day % 5 == 4 {
                                    Image("pleasant")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image("very pleasant")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .frame(width: 50, height: 80)
                            .background(
                                isCurrentDay ? Color.blue :
                                    (day % 2 == 0 ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                            )
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
        .sheet(isPresented: $showFullCalendarView) {
            FullCalendarView()
        }
    }
}

// Full Calendar View
struct FullCalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMonth = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var showYearPicker = false
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    // Create a range of years (current year - 10 to current year + 10)
    var years: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear-10)...(currentYear+10))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Month header with navigation arrows and year
                HStack {
                    Button(action: {
                        if selectedMonth > 0 {
                            selectedMonth -= 1
                        } else {
                            selectedMonth = 11 // Go to December if at January
                            selectedYear -= 1  // Decrease year when going from January to December
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack {
                        Text(months[selectedMonth])
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Button(action: {
                            showYearPicker.toggle()
                        }) {
                            Text(String(format: "%d", selectedYear))
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if selectedMonth < 11 {
                            selectedMonth += 1
                        } else {
                            selectedMonth = 0 // Go to January if at December
                            selectedYear += 1  // Increase year when going from December to January
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                .padding(.vertical)
                
                // Year picker (shown when showYearPicker is true)
                if showYearPicker {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                            ForEach(years, id: \.self) { year in
                                Button(action: {
                                    selectedYear = year
                                    showYearPicker = false
                                }) {
                                    Text(String(format: "%d", year))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(selectedYear == year ? Color.blue : Color.gray.opacity(0.1))
                                        .foregroundColor(selectedYear == year ? .white : .black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                } else {
                    // Day headers
                    HStack {
                        ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Calendar grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        // Calendar days
                        ForEach(daysInSelectedMonth(), id: \.self) { day in
                            if day > 0 {
                                VStack {
                                    Text("\(day)")
                                        .font(.subheadline)
                                    
                                    // Mood image based on day pattern
                                    if day % 5 == 1 {
                                        Image("very unpleasant")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    } else if day % 5 == 2 {
                                        Image("unpleasant")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    } else if day % 5 == 3 {
                                        Image("neutral")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    } else if day % 5 == 4 {
                                        Image("pleasant")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    } else {
                                        Image("very pleasant")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .frame(height: 50)
                                .background(
                                    isCurrentDay(day) ? Color.blue.opacity(0.2) : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            } else {
                                // Empty cell for padding at start of month
                                Color.clear
                                    .frame(height: 50)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Monthly Calendar")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    // Calculate days in the selected month with padding for start of month
    func daysInSelectedMonth() -> [Int] {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear  // Use selectedYear instead of current year
        dateComponents.month = selectedMonth + 1
        
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: dateComponents) else {
            return []
        }
        
        // Get weekday of first day (0 = Sunday, 1 = Monday, etc.)
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        
        // Create array with padding for start of month
        var days = Array(repeating: 0, count: firstWeekday)
        days.append(contentsOf: Array(1...range.count))
        
        return days
    }
    
    // Check if a day is the current day
    func isCurrentDay(_ day: Int) -> Bool {
        let currentMonth = Calendar.current.component(.month, from: Date()) - 1
        let currentDay = Calendar.current.component(.day, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        return selectedMonth == currentMonth && day == currentDay && selectedYear == currentYear
    }
}

struct MoodTrackerAppView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerAppView()
    }
}
