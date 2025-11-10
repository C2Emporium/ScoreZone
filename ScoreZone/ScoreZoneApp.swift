//
//  ScoreZoneApp.swift
//  ScoreZone
//
//  Created by Taylor Wush on 10/23/25.
//

import SwiftUI

@main
struct ScoreZoneApp: App {
    
        @StateObject private var themeManager = ThemeManager()
        @StateObject private var languageManager = LanguageManager()

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(themeManager)
                    .environmentObject(languageManager)
                    .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            }
        }
    
    
}
