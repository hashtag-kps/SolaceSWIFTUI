import SwiftUI

struct SongsListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let songs: [(name: String, description: String)] = [
        ("Radiant", "Postivity"),
        ("Harmonic Ease", "Ease"),
        ("Elevated Spirit", "Uplift"),
        ("Slumber", "Sleep"),
        ("Joyful Calm", "Focus")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songs, id: \.name) { song in
                    HStack(spacing: 16) {
                        // Song Image
                        Image(song.name)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .background(Color.gray.opacity(0.2))
                        
                        // Song Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(song.name)
                                .font(.system(size: 16, weight: .medium))
                            Text(song.description)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Songs")
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
            )
        }
    }
}