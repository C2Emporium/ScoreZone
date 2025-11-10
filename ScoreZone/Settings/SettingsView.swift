//
//  SettingsView.swift
//  ScoreZone
//
//  Created by Taylor Wush on 10/23/25.
//

import SwiftUI
import MessageUI

// MARK: - SettingsView
struct SettingsView: View {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var languageManager = LanguageManager()
    
    @State private var showMailComposer = false
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient selon le thème
                LinearGradient(
                    colors: themeManager.isDarkMode ?
                        [Color.black.opacity(0.95), Color.green.opacity(0.1)] :
                        [Color.white.opacity(0.95), Color.green.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Form {
                    // MARK: Language Section
                    Section(header: Text(languageManager.localized("Language"))
                        .font(.headline)
                        .foregroundColor(.green)
                    ) {
                        Picker(languageManager.localized("Language"), selection: $languageManager.selectedLanguage) {
                            Text("English").tag("English")
                            Text("French").tag("French")
                            Text("Spanish").tag("Spanish")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    // MARK: Theme Section
                    Section(header: Text(languageManager.localized("Theme"))
                        .font(.headline)
                        .foregroundColor(.green)
                    ) {
                        Picker(languageManager.localized("Theme"), selection: $themeManager.selectedTheme) {
                            Text("Light").tag("Light")
                            Text("Dark").tag("Dark")
                        }
                        .pickerStyle(.menu)
                        .onChange(of: themeManager.selectedTheme) { 
                            applyTheme()
                        }
                    }
                    
                    // MARK: Action Buttons
                    Section {
                        Button(action: { showResetAlert = true }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .foregroundColor(.red)
                                Text(languageManager.localized("Reset Settings"))
                                    .foregroundColor(.red)
                                    .bold()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .alert(isPresented: $showResetAlert) {
                            Alert(
                                title: Text(languageManager.localized("Reset Settings")),
                                message: Text("Are you sure you want to reset all settings to default?"),
                                primaryButton: .destructive(Text(languageManager.localized("Reset Settings"))) {
                                    resetSettings()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        Button(action: { showMailComposer = true }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text(languageManager.localized("Contact Support"))
                                    .foregroundColor(.blue)
                                    .bold()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .sheet(isPresented: $showMailComposer) {
                            MailView(isShowing: $showMailComposer, recipient: "support@scorezone.com")
                        }
                    }
                }
                .navigationTitle(languageManager.localized("Settings"))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
            }
            .onAppear {
                applyTheme()
            }
        }
    }
    
    // MARK: - Reset Settings
    func resetSettings() {
        themeManager.reset()
        languageManager.reset()
        applyTheme()
    }
    
    // MARK: - Apply Theme
    func applyTheme() {
        let style: UIUserInterfaceStyle = themeManager.isDarkMode ? .dark : .light
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.overrideUserInterfaceStyle = style
    }
}

// MARK: - Mail Composer
struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let recipient: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients([recipient])
        vc.setSubject("Support Request")
        vc.mailComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        init(_ parent: MailView) { self.parent = parent }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isShowing = false
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
