//
// MatchesView.swift
// ScoreZone
//
// Created by Taylor Wush on 10/23/25.
//

import SwiftUI
import WebKit
import AVFoundation
import AudioToolbox

// MARK: - Models
struct MatchesResponse: Codable {
let matches: [Match]
}

struct Match: Identifiable, Codable {
let id: Int
let utcDate: Date
let status: String
let minute: Int?
let venue: String?
let referees: [Referee]?
let competition: Competition
let homeTeam: Team
let awayTeam: Team
let score: Score
let attendance: Int?
let date: Date?
}

struct Competition: Codable {
let id: Int
let name: String
}

struct Team: Codable {
let id: Int?
let name: String
let shortName: String?
let tla: String?
let crest: String?
}

struct Referee: Codable {
let id: Int?
let name: String?
let role: String?
}

struct Score: Codable {
let winner: String?
let fullTime: ScoreTime?
let halfTime: ScoreTime?
let extraTime: ScoreTime?
let penalties: ScoreTime?
}

struct ScoreTime: Codable {
let home: Int?
let away: Int?
}

// MARK: - Date Extension
extension Date {
func formattedDateTimeShort() -> String {
let fmt = DateFormatter()
fmt.dateStyle = .medium
fmt.timeStyle = .short
return fmt.string(from: self)
}
func isoDateString() -> String {
let fmt = DateFormatter()
fmt.dateFormat = "yyyy-MM-dd"
fmt.timeZone = TimeZone(secondsFromGMT: 0)
return fmt.string(from: self)
}
}

// MARK: - AdBannerView
struct AdBannerView: UIViewRepresentable {
let htmlString: String
func makeUIView(context: Context) -> WKWebView {
let webView = WKWebView()
webView.scrollView.isScrollEnabled = false
webView.isOpaque = false
webView.loadHTMLString(htmlString, baseURL: nil)
return webView
}
func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// MARK: - MatchesView
struct MatchesView: View {
@Binding var selectedSport: String
@Binding var showSportsMenu: Bool
@State private var matches: [Match] = []
@State private var isLoading = false
@State private var showLive = false
@State private var showDatePicker = false
@State private var showSearch = false
@State private var selectedDate = Date()
@State private var searchText = ""
@State private var selectedCompetition: CompetitionOption = .championsLeague

enum CompetitionOption: String, CaseIterable, Identifiable {
case championsLeague = "CL"
case premierLeague = "PL"
case laLiga = "PD"
case serieA = "SA"
case bundesliga = "BL1"
var id: String { rawValue }
var displayName: String {
switch self {
case .championsLeague: return "UEFA C1"
case .premierLeague: return "Premier League"
case .laLiga: return "La Liga"
case .serieA: return "Serie A"
case .bundesliga: return "Bundesliga"
}
}
}

var filteredMatches: [Match] {
var list = matches
if showLive {
list = list.filter { $0.status == "LIVE" || $0.status == "IN_PLAY" }
}
if !searchText.isEmpty {
list = list.filter {
$0.homeTeam.name.localizedCaseInsensitiveContains(searchText) ||
$0.awayTeam.name.localizedCaseInsensitiveContains(searchText) ||
$0.competition.name.localizedCaseInsensitiveContains(searchText)
}
}
return list
}
var body: some View {
NavigationView {
VStack(spacing: 0) {
// MARK: Header
VStack (spacing: 6){
MainHeaderView(
selectedSport: $selectedSport,
showSportsMenu: $showSportsMenu,
showLive: $showLive,
showDatePicker: $showDatePicker,
showSearch: $showSearch,
selectedDate: $selectedDate,
searchText: $searchText
)
Picker("Competition", selection: $selectedCompetition) {
ForEach (CompetitionOption.allCases) { comp in
Text(comp.displayName).tag(comp)
}
}
.pickerStyle(SegmentedPickerStyle())
.padding(.bottom)
.onChange(of: selectedCompetition) {
Task { await loadMatches() }
}
}
// MARK: Ad Banner
AdBannerView(htmlString: """
<div style='display:flex; justify-content:center; align-items:center; width:100%; overflow:hidden;'>
<iframe
scrolling='yes'
frameborder='0'
style='border:none; width:100%; max-width:800px; height:150px;'
src='https://refbanners.com/I?tag=d_4827732m_54037c_&site=4827732&ad=54037'>
</iframe>
</div>
""")
.frame(maxWidth: .infinity)
.frame(height: 150)
.padding(.horizontal, -40)
.padding(.bottom, -80)
// MARK: DatePicker
if showDatePicker {
VStack {
DatePicker("Select date", selection: $selectedDate, displayedComponents: [.date])
.datePickerStyle(GraphicalDatePickerStyle())
.padding()
Button(action: { showDatePicker = false }) {
HStack {
Spacer()
Text("Valider").bold()
Image(systemName: "checkmark")
Spacer()
}
.padding()
.background(Color.green.opacity(0.8))
.foregroundColor(.white)
.cornerRadius(10)
}
.padding(.horizontal)
}
}
// MARK: Search
if showSearch {
HStack {
TextField("Search match, team, competition", text: $searchText)
.textFieldStyle(RoundedBorderTextFieldStyle())
Button(action: { showSearch = false }) {
Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
}
}
.padding(.horizontal)
.padding(.bottom, 6)
}
// MARK: Matches List - Ultra Pro Design
if isLoading {
ProgressView("Loading matches...")
.frame(maxWidth: .infinity, maxHeight: .infinity)
} else if filteredMatches.isEmpty {
Text(showLive ? "No live matches currently." : "No matches for selected date.")
.foregroundColor(.gray)
.font(.title3)
.padding(.top, 40)
.frame(maxWidth: .infinity, maxHeight: .infinity)
} else {
ScrollView {
LazyVStack(spacing: 12) {
ForEach(filteredMatches) { match in
NavigationLink(destination: MatchDetailView(match: match)) {
HStack(spacing: 12) {
// Home Team
VStack(spacing: 6) {
AsyncImage(url: URL(string: match.homeTeam.crest ?? "")) { image in
image.resizable().scaledToFit()
} placeholder: {
Color.gray.opacity(0.3)
}
.frame(width: 50, height: 50)
.clipShape(Circle())
.shadow(color: .green.opacity(0.4), radius: 3)
Text(match.homeTeam.name)
.font(.subheadline)
.bold()
.multilineTextAlignment(.center)
.foregroundColor(match.score.winner == "HOME_TEAM" ? .green : .white)
}
.frame(maxWidth: .infinity)
// Score & Status
VStack(spacing: 6) {
HStack(spacing: 4) {
Text("\(match.score.fullTime?.home ?? 0)")
.font(.title)
.bold()
.foregroundColor(match.score.winner == "HOME_TEAM" ? .green : .white)
Text("-")
.font(.title2)
.foregroundColor(.gray)
Text("\(match.score.fullTime?.away ?? 0)")
.font(.title)
.bold()
.foregroundColor(match.score.winner == "AWAY_TEAM" ? .green : .white)
}
if let minute = match.minute {
Text("\(minute)'")
.font(.caption2)
.foregroundColor(.gray)
}
if match.status.uppercased().contains("LIVE") {
HStack(spacing: 4) {
Circle()
.fill(Color.red)
.frame(width: 8, height: 8)
.scaleEffect(1.2)
.animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: UUID())
Text("LIVE")
.font(.caption2)
.bold()
.foregroundColor(.red)
}
} else {
Text(match.status.uppercased())
.font(.caption2)
.foregroundColor(.gray)
}
}
.frame(maxWidth: .infinity)
// Away Team
VStack(spacing: 6) {
AsyncImage(url: URL(string: match.awayTeam.crest ?? "")) { image in
image.resizable().scaledToFit()
} placeholder: {
Color.gray.opacity(0.3)
}
.frame(width: 50, height: 50)
.clipShape(Circle())
.shadow(color: .green.opacity(0.4), radius: 3)
Text(match.awayTeam.name)
.font(.subheadline)
.bold()
.multilineTextAlignment(.center)
.foregroundColor(match.score.winner == "AWAY_TEAM" ? .green : .white)
}
.frame(maxWidth: .infinity)
}
.padding()
.background(
LinearGradient(
colors: [Color.black.opacity(0.85), Color.green.opacity(0.1)],
startPoint: .top,
endPoint: .bottom
)
)
.cornerRadius(15)
.shadow(color: .green.opacity(0.3), radius: 5)
.padding(.horizontal)
}
}
}
.padding(.vertical)
}
}
}
.navigationBarHidden(true)
}
.task { await loadMatches() }
.onChange(of: selectedSport) { Task { await loadMatches() } }
.onChange(of: selectedDate) { Task { await loadMatches() } }
.onChange(of: showLive) { Task { await loadMatches() } }
}
// MARK: - Load Matches (adjusted for selected competition)
func loadMatches() async {
isLoading = true
defer { isLoading = false }
let dateStr = selectedDate.isoDateString()
// Dynamically use selected competition code
let competitionCode = selectedCompetition.rawValue
let urlString = "https://api.football-data.org/v4/competitions/\(competitionCode)/matches?dateFrom=\(dateStr)&dateTo=\(dateStr)"
guard let url = URL(string: urlString) else { return }
var request = URLRequest(url: url)
request.setValue("0542e9fd458441e59c931e8dad4dee1c", forHTTPHeaderField: "X-Auth-Token")
do {
let (data, _) = try await URLSession.shared.data(for: request)
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
let decoded = try decoder.decode(MatchesResponse.self, from: data)
await MainActor.run { matches = decoded.matches.sorted { $0.utcDate < $1.utcDate } }
} catch {
print("Erreur chargement matches:", error)
}
}
}

// MARK: - MatchDetailView Ultra Pro
struct MatchDetailView: View {
let match: Match
@State private var pulse = false
var body: some View {
ScrollView {
VStack(spacing: 20) {
// MARK: Header
VStack(spacing: 6) {
Text(match.competition.name)
.font(.title2)
.bold()
.foregroundColor(.green)
Text("\(match.homeTeam.name) vs \(match.awayTeam.name)")
.font(.title3)
.foregroundColor(.white)
Text(match.utcDate.formattedDateTimeShort())
.font(.subheadline)
.foregroundColor(.gray)
}
.padding(.top)
// MARK: Score Card
VStack(spacing: 16) {
HStack(spacing: 30) {
// Home Team
VStack(spacing: 8) {
AsyncImage(url: URL(string: match.homeTeam.crest ?? "")) { image in
image.resizable().scaledToFit()
} placeholder: {
Color.gray.opacity(0.3)
}
.frame(width: 80, height: 80)
.clipShape(Circle())
.shadow(color: .green.opacity(0.5), radius: 5)
Text(match.homeTeam.name)
.font(.headline)
.multilineTextAlignment(.center)
.foregroundColor(match.score.winner == "HOME_TEAM" ? .green : .white)
}
// Score + Status
VStack(spacing: 8) {
HStack(spacing: 6) {
Text("\(match.score.fullTime?.home ?? 0)")
.font(.system(size: 52, weight: .bold))
.foregroundColor(match.score.winner == "HOME_TEAM" ? .green : .white)
Text("-")
.font(.system(size: 48, weight: .medium))
.foregroundColor(.gray)
Text("\(match.score.fullTime?.away ?? 0)")
.font(.system(size: 52, weight: .bold))
.foregroundColor(match.score.winner == "AWAY_TEAM" ? .green : .white)
}
HStack(spacing: 6) {
if match.status.uppercased().contains("LIVE") {
Circle()
.fill(Color.red)
.frame(width: 10, height: 10)
.scaleEffect(pulse ? 1.3 : 0.8)
.shadow(color: .red.opacity(0.6), radius: 6)
.animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
.onAppear { pulse = true }
Text("LIVE")
.font(.subheadline)
.bold()
.foregroundColor(.red)
} else {
Text(match.status.uppercased())
.font(.subheadline)
.foregroundColor(.gray)
}
if let minute = match.minute {
Text("\(minute)'")
.font(.caption2)
.foregroundColor(.gray)
}
}
if let ht = match.score.halfTime {
Text("HT \(ht.home ?? 0)-\(ht.away ?? 0)")
.font(.caption2)
.foregroundColor(.gray)
}
}
// Away Team
VStack(spacing: 8) {
AsyncImage(url: URL(string: match.awayTeam.crest ?? "")) { image in
image.resizable().scaledToFit()
} placeholder: {
Color.gray.opacity(0.3)
}
.frame(width: 80, height: 80)
.clipShape(Circle())
.shadow(color: .green.opacity(0.5), radius: 5)
Text(match.awayTeam.name)
.font(.headline)
.multilineTextAlignment(.center)
.foregroundColor(match.score.winner == "AWAY_TEAM" ? .green : .white)
}
}
.padding()
.background(
LinearGradient(
colors: [Color.black.opacity(0.85), Color.green.opacity(0.1)],
startPoint: .top,
endPoint: .bottom
)
)
.cornerRadius(20)
.shadow(color: .green.opacity(0.4), radius: 8)
// MARK: Extra Score Details
VStack(spacing: 6) {
if let extra = match.score.extraTime {
Text("Extra Time: \(extra.home ?? 0)-\(extra.away ?? 0)")
.font(.subheadline)
.foregroundColor(.gray)
}
if let pen = match.score.penalties {
Text("Penalties: \(pen.home ?? 0)-\(pen.away ?? 0)")
.font(.subheadline)
.foregroundColor(.gray)
}
}
}
.padding(.horizontal)
// MARK: Match Info Card
VStack(alignment: .leading, spacing: 10) {
if let venue = match.venue {
HStack {
Label("Venue", systemImage: "map.fill")
.foregroundColor(.gray)
Spacer()
Text(venue)
.foregroundColor(.white)
}
}
if let attendance = match.attendance {
HStack {
Label("Attendance", systemImage: "person.3.fill")
.foregroundColor(.gray)
Spacer()
Text("\(attendance)")
.foregroundColor(.white)
}
}
HStack {
Label("Date & Time", systemImage: "clock.fill")
.foregroundColor(.gray)
Spacer()
Text(match.utcDate.formattedDateTimeShort())
.foregroundColor(.white)
}
HStack {
Label("Competition", systemImage: "trophy.fill")
.foregroundColor(.gray)
Spacer()
Text(match.competition.name)
.foregroundColor(.white)
}
if let referees = match.referees, !referees.isEmpty {
VStack(alignment: .leading, spacing: 4) {
Label("Referees", systemImage: "person.fill.badge.plus")
.foregroundColor(.gray)
ForEach(referees, id: \.id) { ref in
Text("\(ref.name ?? "") (\(ref.role ?? ""))")
.foregroundColor(.white)
.font(.caption)
}
}
}
}
.padding()
.background(Color.black.opacity(0.7))
.cornerRadius(15)
.padding(.horizontal)
.padding(.bottom)
}
.background(Color.black.edgesIgnoringSafeArea(.all))
}
.navigationTitle("Match Details")
.navigationBarTitleDisplayMode(.inline)
}
}

// MARK: - Preview
#Preview {
    ContentView()
}
