//
//  SynthesizedCodeTextViews.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/6/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation

class SynthesizedCodeTextViews {
    static func update(synthesizedCode: SchemeTextView!,
                       fromCodeSynthesis notification: Notification) {
        guard let userInfo = notification.userInfo,
            let code = userInfo["message"] as? String else {
            assertionFailure("Expected the synthesized code.")
            abort()
        }

        synthesizedCode.text = code
    }
}
