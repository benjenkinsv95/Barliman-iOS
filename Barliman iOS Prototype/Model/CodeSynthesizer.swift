//
//  Synthesizer.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/6/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

extension Notification.Name {
    static let codeSynthesisCompleted
        = NSNotification.Name("codeSynthesisCompleted")
    static let codeSynthesisStarted
        = NSNotification.Name("codeSynthesisStarted")
}

protocol CodeSynthesizer {
    func synthesize()
}

class DefaultCodeSynthesizer: CodeSynthesizer {
    private static let codeSynthesisProvider = MoyaProvider<CodeSynthesisService>()
    static var instance = DefaultCodeSynthesizer()
    private var project = DefaultProject.instance
    var synthesizedCode: String = "N/A"

    private init() {
    }

    func synthesize() {
        NotificationCenter.default.post(name: .codeSynthesisStarted, object: self, userInfo: ["message": "Working on it..."])

        DefaultCodeSynthesizer.codeSynthesisProvider.request(
            CodeSynthesisService.synthesize(codeDefinition: project.codeDefinition,
                                            testInput: project.testInput,
                                            textExpectedOutput: project.textExpectedOutput)) { response in
            switch response {
            case let .success(moyaResponse):
                guard moyaResponse.statusCode < 300 else {
                    // Our definitions of success are very different Moya. :P
                    self.synthesizedCode = "Failed to synthesize code!"
                    NotificationCenter.default.post(name: .codeSynthesisCompleted, object: self, userInfo: ["message": self.synthesizedCode])

                    return
                }

                let projectJson: JSON
                do {
                    projectJson = try JSON(data: moyaResponse.data)
                    print("Received following response from server:\n\(moyaResponse.data.toString())")
                } catch {
                    assertionFailure("Failed to load JSON")
                    abort()
                }

                guard let newSynthesizedCode = projectJson["payload"].string
                else {
                    assertionFailure("Couldn't extract fields from JSON. Maybe the API changed?")
                    abort()
                }

                self.synthesizedCode = newSynthesizedCode
                NotificationCenter.default.post(name: .codeSynthesisCompleted, object: self, userInfo: ["message": newSynthesizedCode])
            case .failure:
                self.synthesizedCode = "Failed to synthesize code!"
                NotificationCenter.default.post(name: .codeSynthesisCompleted, object: self, userInfo: ["message": self.synthesizedCode])
            }
        }
    }
}
