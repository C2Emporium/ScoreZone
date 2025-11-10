//
//  LeagueMatchesView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import SwiftUI
import AVFoundation

struct LeagueMatchesView: View {
    let leagueCode: String
    let leagueName: String

    @StateObject private var viewModel = LeagueMatchesViewModel()
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if viewModel.isLoading {
                    ProgressView("Chargement des matchs...")
                        .padding()
                } else if viewModel.matches.isEmpty {
                    Text("Aucun match disponible pour cette ligue.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.matches) { match in
                        NavigationLink(destination: LeagueMatchDetailPage(match: match)) {
                            LeagueMatchCardView(match: match)
                                .environmentObject(favoritesVM)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(leagueName)
        .onAppear {
            viewModel.fetchMatches(leagueCode: leagueCode)
            viewModel.startAutoRefresh(leagueCode: leagueCode)
        }
        .onDisappear {
            viewModel.stopAutoRefresh()
        }
    }
}

// MARK: - ViewModel
class LeagueMatchesViewModel: ObservableObject {
    @Published var matches: [APIMatch] = []
    @Published var isLoading = false

    private var timer: Timer?
    private let apiService = APIService()

    func fetchMatches(leagueCode: String) {
        isLoading = true
        Task {
            do {
                let data = try await apiService.fetchMatches(for: leagueCode)
                DispatchQueue.main.async {
                    self.matches = data.sorted { $0.utcDate < $1.utcDate }
                    self.isLoading = false
                }
            } catch {
                print("Erreur fetchMatches:", error)
                DispatchQueue.main.async { self.isLoading = false }
            }
        }
    }

    func startAutoRefresh(leagueCode: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.fetchMatches(leagueCode: leagueCode)
        }
    }

    func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - MatchCardView avec bouton favoris
struct LeagueMatchCardView: View {
    let match: APIMatch
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        HStack(spacing: 12) {
            // Logo domicile
            AsyncImage(url: URL(string: match.homeTeam.logo ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())

            Text(match.homeTeam.name)
                .font(.subheadline)
                .bold()

            Spacer()

            VStack {
                Text(getScore())
                    .font(.headline)
                Text(formatUTC(match.utcDate))
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(match.status)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(getStatusColor())
            }

            Spacer()

            Text(match.awayTeam.name)
                .font(.subheadline)
                .bold()

            // Logo extérieur
            AsyncImage(url: URL(string: match.awayTeam.logo ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())

            // ⭐️ Bouton favoris
            Button(action: {
                if favoritesVM.isFavorite(match) {
                    favoritesVM.removeFromFavorites(match)
                } else {
                    favoritesVM.addToFavorites(match)
                }
            }) {
                Image(systemName: favoritesVM.isFavorite(match) ? "star.fill" : "star")
                    .foregroundColor(favoritesVM.isFavorite(match) ? .yellow : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
        )
    }

    private func getScore() -> String {
        if match.status == "SCHEDULED" { return "VS" }
        let home = match.score.fullTime?.homeTeam ?? 0
        let away = match.score.fullTime?.awayTeam ?? 0
        return "\(home) - \(away)"
    }

    private func getStatusColor() -> Color {
        switch match.status {
        case "LIVE": return .red
        case "FINISHED": return .green
        default: return .blue
        }
    }

    private func formatUTC(_ utc: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: utc) {
            let output = DateFormatter()
            output.dateFormat = "HH:mm, dd MMM"
            return output.string(from: date)
        }
        return utc
    }
}

// MARK: - MatchDetailPage
struct LeagueMatchDetailPage: View {
    let match: APIMatch
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack {
                    Text(match.homeTeam.name).bold()
                    Text("\(match.score.fullTime?.homeTeam ?? 0)")
                }

                Spacer()

                Text("-")

                Spacer()

                VStack {
                    Text(match.awayTeam.name).bold()
                    Text("\(match.score.fullTime?.awayTeam ?? 0)")
                }
            }
            .font(.title2)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Statistiques détaillées non disponibles dans votre plan API")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

            Spacer()
        }
        .padding()
        .navigationTitle("Détails match")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LeagueMatchesView(leagueCode: "PL", leagueName: "Premier League")
            .environmentObject(FavoritesViewModel())
    }
}
