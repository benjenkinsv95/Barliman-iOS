//
//  CodeSynthesisService.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/6/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation
import Moya

enum CodeSynthesisService {
    case synthesize(codeDefinition: String, testInput: String, textExpectedOutput: String)
}

extension CodeSynthesisService: TargetType {
    var baseURL: URL { return URL(string: "http://barliman.ben-jenkins.com:4000")! }
    var path: String {
        switch self {
        case .synthesize:
            return "/synthesize"
        }
    }
    var method: Moya.Method {
        switch self {
        case .synthesize:
            return .post
        }
    }
    var task: Task {
        class Test: Codable {
            let id: Int
            let input: String
            let output: String

            init(id: Int, input: String, output: String) {
                self.id = id
                self.input = input
                self.output = output
            }

            func toJSON() -> Dictionary<String, Any> {
                return [
                    "id": self.id,
                    "input": self.input,
                    "output": self.output,
                ]
            }
        }

        switch self {
        case let .synthesize(codeDefinition, testInput, textExpectedOutput): // Always send parameters as JSON in request body
            return .requestParameters(parameters: [
                "definition": codeDefinition,
                "tests": [
                    Test(id: 1, input: testInput, output: textExpectedOutput).toJSON(),
                ],
            ], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    // Why is this part of the protocol??
    var sampleData: Data {
        switch self {
        case .synthesize:
            return "{ payload\": \"(define append\n  (lambda (left right)\n    (if (null? right) left (cons (car left) right))))\n\n\n\n}".utf8Encoded
        }
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
