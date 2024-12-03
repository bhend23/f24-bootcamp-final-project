//
//  DecodingService.swift
//  final.project.musicplayer
//
//  Created by Brandon Henderson on 11/19/24.
//
import SwiftUI
import Foundation

struct SpotifySearchResponse: Codable {
    let tracks: TrackResponse
}

struct TrackResponse: Codable {
    let items: [Track]
}

struct Track: Codable, Identifiable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album

    var artistNames: String {
        artists.map { $0.name }.joined(separator: ", ")
    }
}

struct Artist: Codable {
    let name: String
}

struct Album: Codable {
    let images: [Image]
}

struct Image: Codable {
    let url: String
}
