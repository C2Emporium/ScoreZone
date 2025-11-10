//
//  LeaguesViewModel.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import Foundation
import SwiftUI

@MainActor
class LeaguesViewModel: ObservableObject {
    private let apiService = APIService()
    
    @Published var leagueMatches: [String: [APIMatch]] = [:]
    
    func loadMatches(for leagueCode: String) async {
        do {
            let matches = try await apiService.fetchMatches(for: leagueCode)
            leagueMatches[leagueCode] = matches
        } catch {
            print("Erreur chargement matches pour \(leagueCode):", error)
        }
    }
    
    func startAutoRefresh(for leagueCodes: [String]) {
        Task {
            while true {
                for code in leagueCodes {
                    await loadMatches(for: code)
                }
                try? await Task.sleep(nanoseconds: 30 * 1_000_000_000) // 30s
            }
        }
    }
}
