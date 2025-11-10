//
//  MatchDetailView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//
import SwiftUI
import AVFoundation

struct MatchDetailPage: View {  // anciennement MatchDetailView
    let match: APIMatch
    
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
        }
        .padding()
        .navigationTitle("Détails match")
    }
}
