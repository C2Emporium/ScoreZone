//
//  ThemeManager.swift
//  ScoreZone
//
//  Created by Taylor Wush on 11/9/25.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: String = "Light" {
        didSet {
            objectWillChange.send()
        }
    }

    var isDarkMode: Bool {
        selectedTheme == "Dark"
    }

    func reset() {
        selectedTheme = "Light"
    }
}
