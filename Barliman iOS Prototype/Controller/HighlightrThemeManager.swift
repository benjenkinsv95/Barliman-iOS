//
//  HighlightrThemeManager.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/10/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation
import Highlightr
import SwiftyUserDefaults

class HighlightrThemeManager {
    public static let instance = HighlightrThemeManager()
    private var views: [SchemeTextView] = []
    public var theme = Defaults[.selectedTheme]

    public var viewCount: Int { return views.count }
    public let allThemes: [String] = CodeAttributedString().highlightr.availableThemes().sorted()

    func register(schemeTextView: SchemeTextView) {
        guard !views.contains(schemeTextView) else {
            print("Attempt to register same text view multiple times.")
            return
        }

        views.append(schemeTextView)
        schemeTextView.setTheme(theme)
    }

    func setTheme(_ theme: String) {
        Defaults[.selectedTheme] = theme
        self.theme = theme
        views.forEach({
            $0.setTheme(theme)
            $0.setNeedsDisplay()
        })
    }
}
