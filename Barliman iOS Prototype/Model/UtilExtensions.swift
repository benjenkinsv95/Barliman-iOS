//
//  UtilExtensions.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/5/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation

extension Data {
    func toString() -> String {
        return String(data: self, encoding: .utf8)!
    }
}
