//
//  Test.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/11/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation

class Test {
    var id: Int
    var name: String { return "Test \(id)" }

    var input: String {
        didSet {
            guard oldValue != input else {
                // Value didnt change, no need to send notification.
                return
            }
            NotificationCenter.default.post(name: .projectUpdated, object: self)
        }
    }

    var expectedOutput: String {
        didSet {
            guard oldValue != expectedOutput else {
                // Value didnt change, no need to send notification.
                return
            }
            NotificationCenter.default.post(name: .projectUpdated, object: self)
        }
    }

    init(id: Int, input: String, expectedOutput: String) {
        self.id = id
        self.input = input
        self.expectedOutput = expectedOutput
    }
}
