//
//  FeedView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 10/23/25.
//

import SwiftUI
import WebKit
import AVFoundation
import AudioToolbox

// MARK: - FeedView et News
struct NewsArticle: Identifiable, Decodable {
    let title: String
    let description: String?
    let url: String
    var id: String { url } // stable ID pour Identifiable
}

struct NewsAPIResponse: Decodable {
    let articles: [NewsArticle]
}

struct FeedView: View {
    @State private var articles: [NewsArticle] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if isLoading { ProgressView("Loading news...") }
                    else if articles.isEmpty { Text("No news available").foregroundColor(.gray) }
                    else {
                        ForEach(articles) { article in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title).font(.headline)
                                if let desc = article.description { Text(desc).font(.subheadline).foregroundColor(.gray) }
                                Link("Read more", destination: URL(string: article.url)!)
                                    .font(.caption).foregroundColor(.blue)
                                Divider()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Sports Feed 📰")
            .task { await loadNews() }
            .refreshable { await loadNews() }
        }
    }
    
    func loadNews() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=sports&language=en&apiKey=53456e7cd9a64bb997aecd8e4a13c401") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
            await MainActor.run { self.articles = decoded.articles }
        } catch {
            print("Erreur chargement news:", error)
        }
    }
}
