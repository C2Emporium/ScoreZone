//
//  MatchCardView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import SwiftUI
import AVFoundation

struct MatchCardView: View {
    let match: APIMatch
    
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
            
            Text(match.homeTeam.name).font(.subheadline).bold()
            
            Spacer()
            
            VStack {
                Text(getScore()).font(.headline)
                Text(formatUTC(match.utcDate)).font(.caption).foregroundColor(.gray)
                Text(match.status).font(.caption2).bold().foregroundColor(getStatusColor())
            }
            
            Spacer()
            
            Text(match.awayTeam.name).font(.subheadline).bold()
            
            // Logo extérieur
            AsyncImage(url: URL(string: match.awayTeam.logo ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
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
