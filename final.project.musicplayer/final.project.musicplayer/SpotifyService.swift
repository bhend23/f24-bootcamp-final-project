//
//  SpotifyService.swift
//  final.project.musicplayer
//
//  Created by Brandon Henderson on 11/19/24.
//
import SwiftUI
import Foundation

class SpotifyService {
    private static let clientID = "c07fd2ca39894d07a660b11f4db9774e"
    private static let clientSecret = "4f957f3454084773bc21b8d8f366a8da"
    private static var accessToken: String?

    static func fetchAccessToken() async throws {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(getBase64Credentials())", forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let token = json["access_token"] as? String {
            accessToken = token
        }
    }

    static func searchTracks(query: String) async throws -> [Track] {
        guard let token = accessToken, !query.isEmpty else { return [] }
        guard let url = URL(string: "https://api.spotify.com/v1/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=track&limit=20") else { return [] }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
        return response.tracks.items
    }

    private static func getBase64Credentials() -> String {
        let credentials = "\(clientID):\(clientSecret)"
        return Data(credentials.utf8).base64EncodedString()
    }
}
