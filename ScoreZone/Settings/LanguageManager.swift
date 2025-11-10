//
//  LanguageManager.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/9/25.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "English" {
        didSet { objectWillChange.send() }
    }

    func reset() {
        selectedLanguage = "English"
    }

    func localized(_ key: String) -> String {
        switch selectedLanguage {
        case "French":
            return frenchTexts[key] ?? key
        case "Spanish":
            return spanishTexts[key] ?? key
        default:
            return key
        }
    }
}

let frenchTexts: [String: String] = [
    "Settings": "Paramètres",
    "Theme": "Thème",
    "Language": "Langue",
    "Reset Settings": "Réinitialiser",
    "Contact Support": "Contacter le support"
]

let spanishTexts: [String: String] = [
    "Settings": "Configuración",
    "Theme": "Tema",
    "Language": "Idioma",
    "Reset Settings": "Restablecer",
    "Contact Support": "Contactar soporte"
]
