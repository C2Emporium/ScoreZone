//
//  ContentView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 10/21/25.
//

import SwiftUI
import WebKit
import AVFoundation
import AudioToolbox





// MARK: - Extensions
extension String {
    func formattedDate() -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            return display.string(from: date)
        }
        return self
    }
}






// MARK: - ContentView principal
struct ContentView: View {
    @State private var showSportsMenu = false
    @State private var selectedSport = "Soccer"
    
    var body: some View {
        TabView {
            MatchesView(selectedSport: $selectedSport, showSportsMenu: $showSportsMenu)
                .tabItem { Image(systemName: "clock"); Text("Matches") }
            LeaguesView()
                .tabItem { Image(systemName: "trophy"); Text("Leagues") }
            FavoritesView()
                .tabItem { Image(systemName: "heart"); Text("Favorites") }
            FeedView()
                .tabItem { Image(systemName: "newspaper"); Text("Feed") }
            SettingsView()
                .tabItem { Image(systemName: "gear"); Text("Settings") }
        }
        .accentColor(.green)
    }
}



// MARK: - Autres tabs






// MARK: - Preview
#Preview {
    ContentView()
}
