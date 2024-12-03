//
//  OpeningView.swift
//  final.project.musicplayer
//
//  Created by Brandon Henderson on 11/19/24.
//
import SwiftUI

struct OpeningView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.carolina
                    .ignoresSafeArea()
                VStack {
                    Text("Welcome to Music Discovery")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Search for your favorite songs and build playlists!")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    Spacer()
                    NavigationLink("Get Started") {
                        ContentView()
                    }
                    .foregroundColor(.white)
                    .padding(4)
                    .bold()
                    .background(Color.navy)
                    .cornerRadius(110)
                    .font(.title)
                    Spacer()
                }
            }
        }
    }
}
    
    #Preview {
        OpeningView()
    }
