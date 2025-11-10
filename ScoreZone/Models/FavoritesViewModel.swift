//
//  FavoritesViewModel.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import Foundation
import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteMatches: [APIMatch] = []

    func addToFavorites(_ match: APIMatch) {
        if !favoriteMatches.contains(where: { $0.id == match.id }) {
            favoriteMatches.append(match)
        }
    }

    func removeFromFavorites(_ match: APIMatch) {
        favoriteMatches.removeAll { $0.id == match.id }
    }

    func isFavorite(_ match: APIMatch) -> Bool {
        favoriteMatches.contains { $0.id == match.id }
    }
}
