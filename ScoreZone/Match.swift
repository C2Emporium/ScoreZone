//
//  Match.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import Foundation

struct GameMatch: Identifiable, Hashable {
    let id = UUID()
    let homeTeam: String
    let awayTeam: String
    let date: Date
}

