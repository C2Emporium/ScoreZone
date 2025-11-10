//
//  LeaguesView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import SwiftUI
import AVFoundation

struct LeaguesView: View {
    @StateObject var themeManager = ThemeManager()
    @StateObject var languageManager = LanguageManager()
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    // Liste complète de continents, pays et ligues (TON CODE COMPLÈTEMENT INCHANGÉ)
    let continents: [ContinentLeagues] = [
        // 🏴 EUROPE
        ContinentLeagues(
            continent: "Europe",
            countries: [
                CountryLeagues(
                    country: "England",
                    flag: "🇬🇧",
                    leagues: [
                        League(name: "Premier League", code: "PL"),
                        League(name: "Championship", code: "ELC"),
                        League(name: "FA Cup", code: "// TODO"),
                        League(name: "EFL Cup", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Spain",
                    flag: "🇪🇸",
                    leagues: [
                        League(name: "La Liga", code: "PD"),
                        League(name: "Segunda Division", code: "// TODO"),
                        League(name: "Copa del Rey", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Italy",
                    flag: "🇮🇹",
                    leagues: [
                        League(name: "Serie A", code: "SA"),
                        League(name: "Serie B", code: "// TODO"),
                        League(name: "Coppa Italia", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Germany",
                    flag: "🇩🇪",
                    leagues: [
                        League(name: "Bundesliga", code: "BL1"),
                        League(name: "2. Bundesliga", code: "// TODO"),
                        League(name: "DFB Pokal", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "France",
                    flag: "🇫🇷",
                    leagues: [
                        League(name: "Ligue 1", code: "FL1"),
                        League(name: "Ligue 2", code: "// TODO"),
                        League(name: "Coupe de France", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Portugal",
                    flag: "🇵🇹",
                    leagues: [
                        League(name: "Primeira Liga", code: "PPL"),
                        League(name: "Liga Portugal 2", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Netherlands",
                    flag: "🇳🇱",
                    leagues: [
                        League(name: "Eredivisie", code: "DED"),
                        League(name: "KNVB Beker", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Turkey",
                    flag: "🇹🇷",
                    leagues: [
                        League(name: "Süper Lig", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Belgium",
                    flag: "🇧🇪",
                    leagues: [
                        League(name: "Pro League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Scotland",
                    flag: "🏴",
                    leagues: [
                        League(name: "Scottish Premiership", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Switzerland",
                    flag: "🇨🇭",
                    leagues: [
                        League(name: "Super League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Russia",
                    flag: "🇷🇺",
                    leagues: [
                        League(name: "Premier League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Greece",
                    flag: "🇬🇷",
                    leagues: [
                        League(name: "Super League", code: "// TODO")
                    ]
                )
            ]
        ),

        // 🌎 AMÉRIQUE DU SUD
        ContinentLeagues(
            continent: "Amérique du Sud",
            countries: [
                CountryLeagues(
                    country: "Brazil",
                    flag: "🇧🇷",
                    leagues: [
                        League(name: "Campeonato Brasileiro Série A", code: "BSA"),
                        League(name: "Copa do Brasil", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Argentina",
                    flag: "🇦🇷",
                    leagues: [
                        League(name: "Liga Profesional", code: "// TODO"),
                        League(name: "Copa de la Liga", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Colombia",
                    flag: "🇨🇴",
                    leagues: [
                        League(name: "Categoría Primera A", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Chile",
                    flag: "🇨🇱",
                    leagues: [
                        League(name: "Primera División", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Uruguay",
                    flag: "🇺🇾",
                    leagues: [
                        League(name: "Primera División", code: "// TODO")
                    ]
                )
            ]
        ),

        // 🇺🇸 AMÉRIQUE DU NORD / CENTRALE
        ContinentLeagues(
            continent: "Amérique du Nord",
            countries: [
                CountryLeagues(
                    country: "USA",
                    flag: "🇺🇸",
                    leagues: [
                        League(name: "Major League Soccer (MLS)", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Mexico",
                    flag: "🇲🇽",
                    leagues: [
                        League(name: "Liga MX", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Canada",
                    flag: "🇨🇦",
                    leagues: [
                        League(name: "Canadian Premier League", code: "// TODO")
                    ]
                )
            ]
        ),

        // 🌍 AFRIQUE
        ContinentLeagues(
            continent: "Afrique",
            countries: [
                CountryLeagues(
                    country: "Egypt",
                    flag: "🇪🇬",
                    leagues: [
                        League(name: "Egyptian Premier League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Morocco",
                    flag: "🇲🇦",
                    leagues: [
                        League(name: "Botola Pro", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "South Africa",
                    flag: "🇿🇦",
                    leagues: [
                        League(name: "Premier Division (PSL)", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Nigeria",
                    flag: "🇳🇬",
                    leagues: [
                        League(name: "Nigeria Professional Football League", code: "// TODO")
                    ]
                )
            ]
        ),

        // 🌏 ASIE & MOYEN-ORIENT
        ContinentLeagues(
            continent: "Asie & Moyen-Orient",
            countries: [
                CountryLeagues(
                    country: "Japan",
                    flag: "🇯🇵",
                    leagues: [
                        League(name: "J1 League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "China",
                    flag: "🇨🇳",
                    leagues: [
                        League(name: "Chinese Super League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Saudi Arabia",
                    flag: "🇸🇦",
                    leagues: [
                        League(name: "Saudi Pro League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "Qatar",
                    flag: "🇶🇦",
                    leagues: [
                        League(name: "Qatar Stars League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "South Korea",
                    flag: "🇰🇷",
                    leagues: [
                        League(name: "K League 1", code: "// TODO")
                    ]
                )
            ]
        ),

        // 🇦🇺 OCÉANIE
        ContinentLeagues(
            continent: "Océanie",
            countries: [
                CountryLeagues(
                    country: "Australia",
                    flag: "🇦🇺",
                    leagues: [
                        League(name: "A-League", code: "// TODO")
                    ]
                ),
                CountryLeagues(
                    country: "New Zealand",
                    flag: "🇳🇿",
                    leagues: [
                        League(name: "National League", code: "// TODO")
                    ]
                )
            ]
        ),

        // 🏆 COMPÉTITIONS INTERNATIONALES
        ContinentLeagues(
            continent: "Compétitions internationales",
            countries: [
                CountryLeagues(
                    country: "International",
                    flag: "🌐",
                    leagues: [
                        League(name: "FIFA World Cup", code: "WC"),
                        League(name: "UEFA Champions League", code: "CL"),
                        League(name: "UEFA Europa League", code: "// TODO"),
                        League(name: "UEFA Euro", code: "EC"),
                        League(name: "Copa America", code: "// TODO"),
                        League(name: "Africa Cup of Nations (AFCON)", code: "// TODO"),
                        League(name: "AFC Asian Cup", code: "// TODO"),
                        League(name: "CONCACAF Gold Cup", code: "// TODO")
                    ]
                )
            ]
        )
    ]

    @State private var expandedCountries: Set<UUID> = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(continents) { continent in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(continent.continent)
                                .font(.title2.bold())
                                .padding(.horizontal)

                            ForEach(continent.countries) { country in
                                CountrySectionView(
                                    country: country,
                                    isExpanded: expandedCountries.contains(country.id),
                                    toggleExpand: {
                                        if expandedCountries.contains(country.id) {
                                            expandedCountries.remove(country.id)
                                        } else {
                                            expandedCountries.insert(country.id)
                                        }
                                        AudioServicesPlaySystemSound(1104)
                                    },
                                    favoritesVM: favoritesVM
                                )
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle(languageManager.localized("Leagues"))
        }
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

// MARK: - Country Section
struct CountrySectionView: View {
    let country: CountryLeagues
    let isExpanded: Bool
    let toggleExpand: () -> Void
    @ObservedObject var favoritesVM: FavoritesViewModel

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(country.flag) \(country.country)")
                    .font(.headline)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .onTapGesture { toggleExpand() }

            if isExpanded {
                VStack(spacing: 6) {
                    ForEach(country.leagues) { league in
                        if let code = league.code {
                            NavigationLink(destination: LeagueMatchesView(leagueCode: code, leagueName: league.name)
                                .environmentObject(favoritesVM)
                            ) {
                                LeagueRowView(league: league)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.leading)
                .transition(.opacity.combined(with: .slide))
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .padding(.horizontal)
    }
}

// MARK: - League Row
struct LeagueRowView: View {
    let league: League

    var body: some View {
        HStack {
            Image(systemName: "trophy.fill")
                .foregroundColor(.green)
                .frame(width: 24)
            Text(league.name)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}

// MARK: - Preview
#Preview {
    LeaguesView()
        .environmentObject(FavoritesViewModel())
}
