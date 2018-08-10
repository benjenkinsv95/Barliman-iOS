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
}

public extension UserDefaults {
    func setDefaults() {
        Defaults[.definition] = "(define ,A (lambda ,B ,C))"
    }
}
