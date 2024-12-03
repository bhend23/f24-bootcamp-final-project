import SwiftUI
import Foundation

struct ContentView: View {
    @State private var searchQuery: String = ""
    @State private var tracks: [Track] = []
    @State private var addedSongs: [Track] = []
    var body: some View {
        NavigationStack {
            ZStack{
                Color.carolina
                    .ignoresSafeArea()
                VStack {
                    NavigationLink("Go to Playlist") {
                        PlaylistView(addedSongs: $addedSongs)
                    }
                    .foregroundColor(.white)
                    .bold()
                    .padding(4)
                    .background(Color.navy)
                    .cornerRadius(110)
                    TextField("Search for a song", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            Task {
                                await performSearch()
                            }
                        }
                    
                    List(tracks) { track in
                        VStack(alignment: .leading) {
                            Text(track.name)
                                .font(.headline)
                            Text(track.artistNames)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Button("Add to playlist") {
                                addedSongs.append(track)
                            }
                            .foregroundColor(.navy)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .onAppear {
                    Task {
                        await fetchToken()
                    }
                }
            }
    }
        }
    private func fetchToken() async {
        do {
            try await SpotifyService.fetchAccessToken()
        } catch {
            print("Error fetching access token: \(error)")
        }
    }

    private func performSearch() async {
        do {
            tracks = try await SpotifyService.searchTracks(query: searchQuery)
        } catch {
            print("Error performing search: \(error)")
        }
    }
}




#Preview {
    ContentView()
}

