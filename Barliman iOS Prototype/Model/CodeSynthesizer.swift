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
    var request: Cancellable?

    private init() {
    }

    func synthesize() {
        synthesizedCode = "Working on it..."
        NotificationCenter.default.post(name: .codeSynthesisStarted, object: self, userInfo: ["message": "Working on it..."])

        request?.cancel()
        request = DefaultCodeSynthesizer.codeSynthesisProvider.request(
            CodeSynthesisService.synthesize(codeDefinition: project.codeDefinition,
                                            tests: project.tests)) { response in
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

                guard var newSynthesizedCode = projectJson["payload"].string
                else {
                    assertionFailure("Couldn't extract fields from JSON. Maybe the API changed?")
                    abort()
                }

                // Trim whitespace that server may respond with.
                newSynthesizedCode = newSynthesizedCode.trimmingCharacters(in: .whitespacesAndNewlines)

                // The API currently tells you about side conditions at the end of the response
                // Comment them out so the highlighting works.
                if let range = newSynthesizedCode.range(of: "\nSide conditions:") {
                    newSynthesizedCode = newSynthesizedCode.replacingOccurrences(of: "\n", with: "\n;", options: .literal, range: range.lowerBound ..< newSynthesizedCode.endIndex)
                }

                self.synthesizedCode = newSynthesizedCode
                NotificationCenter.default.post(name: .codeSynthesisCompleted, object: self, userInfo: ["message": newSynthesizedCode])
            case .failure:
                print("Synthesis cancelled!")
            }
        }
    }
}
