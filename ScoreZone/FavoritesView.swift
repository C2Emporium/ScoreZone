//
//  FavoritesView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/10/25.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack {
            Text("Your Favorites ⭐️")
                .font(.title)
                .padding(.top, 20)
            
            Spacer()
            
            // Ici, tu pourras afficher la liste de tes favoris
            Text("No favorites yet 😅")
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Favorites")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
