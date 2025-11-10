//
//  MainHeaderView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 10/23/25.
//

import SwiftUI
import WebKit
import AVFoundation
import AudioToolbox

// MARK: - MainHeaderView
struct MainHeaderView: View {
    @Binding var selectedSport: String
    @Binding var showSportsMenu: Bool
    @Binding var showLive: Bool
    @Binding var showDatePicker: Bool
    @Binding var showSearch: Bool
    @Binding var selectedDate: Date
    @Binding var searchText: String
    
    let sportsList = ["Soccer", "Basketball", "Ice Hockey"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Sport selector
                Button(action: { withAnimation(.spring()) { showSportsMenu.toggle() } }) {
                    HStack(spacing: 4) {
                        Text(selectedSport)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(showSportsMenu ? 180 : 0))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                // LIVE button
                Button(action: { showLive.toggle() }) {
                    Text("LIVE")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(showLive ? .white : .red)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(showLive ? Color.red : Color.white)
                        .clipShape(Capsule())
                }
                
                // Game controller
                NavigationLink(destination: GameView()) {
                    Image(systemName: "gamecontroller")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.leading, 8)
                }
                
                // Date picker
                Button(action: { showDatePicker.toggle() }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.leading, 8)
                }
                
                // Search
                Button(action: { showSearch.toggle() }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 12)
            .background(Color.green.opacity(0.85))
            
            if showSportsMenu {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(sportsList, id: \.self) { sport in
                            Button(action: {
                                selectedSport = sport
                                withAnimation { showSportsMenu = false }
                            }) {
                                Text(sport)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .black))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedSport == sport ? Color.white.opacity(0.3) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color.green.opacity(0.7))
                .transition(.move(edge: .top))
            }
        }
        .shadow(radius: 2)
    }
}
