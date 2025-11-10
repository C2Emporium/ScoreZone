import Foundation

// MARK: - Modèles API
struct APIMatch: Identifiable, Decodable {
    let id: Int
    let utcDate: String
    let status: String
    let homeTeam: Team
    let awayTeam: Team
    let score: Score

    struct Team: Decodable {
        let id: Int
        let name: String
        let logo: String?  // <- Nouvelle propriété pour le logo
    }

    struct Score: Decodable {
        let fullTime: Result?

        struct Result: Decodable {
            let homeTeam: Int?
            let awayTeam: Int?
        }
    }
}

struct FootballDataMatchesResponse: Decodable {
    let matches: [APIMatch]
}


// MARK: - Service API
class APIService {
    private let apiKey = "0542e9fd458441e59c931e8dad4dee1c"
    private let baseURL = "https://api.football-data.org/v4/competitions"
    
    func fetchMatches(for leagueCode: String) async throws -> [APIMatch] {
        let today = Date()
        let dateFrom = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dateTo = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        
        let dateFormatter = ISO8601DateFormatter()
        let dateFromStr = dateFormatter.string(from: dateFrom)
        let dateToStr = dateFormatter.string(from: dateTo)
        
        let urlString = "\(baseURL)/\(leagueCode)/matches?dateFrom=\(dateFromStr)&dateTo=\(dateToStr)"
        guard let url = URL(string: urlString) else { return [] }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(FootballDataMatchesResponse.self, from: data)
        return response.matches
    }
}

