//
//  Defaults.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/3/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let definition = DefaultsKey<String>("definition")
    static let selectedTheme = DefaultsKey<String>("selectedTheme")
}

public extension UserDefaults {
    func setDefaults() {
        if Defaults[.definition] == "" {
            Defaults[.definition] =
                """
                ; ,A ,B and ,C are holes in the program
                ; That barliman will attempt to generate.
                (define ,A
                  (lambda ,B
                    ,C
                   )
                )
                """
        }

        if Defaults[.selectedTheme] == "" {
            Defaults[.selectedTheme] = "dark"
        }
    }
}
