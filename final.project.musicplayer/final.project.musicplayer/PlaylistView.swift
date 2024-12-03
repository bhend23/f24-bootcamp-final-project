//
//  PlaylistView.swift
//  final.project.musicplayer
//
//  Created by Brandon Henderson on 11/19/24.
//
import SwiftUI

struct PlaylistView: View {
    @Binding var addedSongs: [Track]
    @State private var artistNames: [String] = []
    @State private var recommendedSongs: [Track] = []
    var body: some View {
        NavigationStack {
            ZStack {
                Color.carolina
                    .ignoresSafeArea()
                VStack {
                    Text("Your Playlist")
                        .font(.largeTitle)
                        .padding(4)
                        .foregroundColor(.white)
                        .background(Color.navy)
                        .cornerRadius(110)
                        .bold()
                    
                    if addedSongs.isEmpty {
                        Text("No songs added yet.")
                            .foregroundColor(.white)
                            .bold()
                    } else {
                        List {
                            ForEach(0..<addedSongs.count, id: \.self) { index in
                                let song = addedSongs[index]
                                VStack(alignment: .leading) {
                                    Text(song.name)
                                        .font(.headline)
                                    Text(song.artistNames)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Button("Delete from playlist") {
                                        addedSongs.remove(at: index)
                                    }
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        
                        VStack {
                            Text("Recommended Songs")
                                .font(.title2)
                                .padding(4)
                                .foregroundColor(.white)
                                .background(Color.navy)
                                .cornerRadius(110)
                                .bold()
                            
                            if recommendedSongs.isEmpty {
                                Text("No songs in recommended")
                                    .foregroundColor(.white)
                                    .bold()
                            } else {
                                List(recommendedSongs) { song in
                                    VStack(alignment: .leading) {
                                        Text(song.name)
                                            .font(.headline)
                                        Text(song.artistNames)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Button("Add to playlist") {
                                            addedSongs.append(song)
                                        }
                                        .foregroundColor(.navy)
                                    }
                                }
                                .scrollContentBackground(.hidden)
                            }
                        }
                    }
                }
                .onAppear {
                    populateArtistNames()
                    Task {
                        await generateRecommendations()
                    }
                }
                .padding()
            }
        }
    }

    
    private func populateArtistNames() {
        artistNames.removeAll()
        
        for song in addedSongs {
            for artist in song.artists {
                if !artistNames.contains(artist.name) {
                    artistNames.append(artist.name)
                }
            }
        }
    }
    private func generateRecommendations() async {
        guard !artistNames.isEmpty else { return }
        recommendedSongs.removeAll()
        
        for _ in 0..<50 {
            if let randomArtist = artistNames.randomElement() {
                do {
                    let randomSongs = try await SpotifyService.searchTracks(query: randomArtist)
                    if let randomSong = randomSongs.randomElement() {
                        recommendedSongs.append(randomSong)
                    }
                } catch {
                    print("Error fetching songs for artist \(randomArtist): \(error)")
                }
            }
        }
    }
}
#Preview {
    PlaylistView(addedSongs: .constant([]))
}


