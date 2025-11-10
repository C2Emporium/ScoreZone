//
//  LeagueModels.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import Foundation

struct League: Identifiable {
    let id = UUID()
    let name: String
    let code: String?
}

struct CountryLeagues: Identifiable {
    let id = UUID()
    let country: String
    let flag: String
    let leagues: [League]
}

struct ContinentLeagues: Identifiable {
    let id = UUID()
    let continent: String
    let countries: [CountryLeagues]
}


