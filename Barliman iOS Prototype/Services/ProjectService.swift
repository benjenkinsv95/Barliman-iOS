//
//  ProjectService.swift
//  Barliman iOS Prototype
//  A service for Moya. Follows their Getting Started guide here: https://github.com/Moya/Moya.
//  Leaving in some of their comments, because they are useful.
//
//  Created by Ben J on 8/5/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation
import Moya

enum ProjectService {
    case showProject(deviceId: String)
    case createOrUpdateProject(deviceId: String, codeDefinition: String, testInput: String, textExpectedOutput: String)
}

extension ProjectService: TargetType {
    var baseURL: URL { return URL(string: "https://ios-barliman-persistence.ben-jenkins.com")! }
    var path: String {
        switch self {
        case let .showProject(deviceId):
            return "/projects/\(deviceId)"
        case .createOrUpdateProject(let deviceId, _, _, _):
            return "/projects/\(deviceId)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .showProject:
            return .get
        case .createOrUpdateProject:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .showProject: // Send no parameters
            return .requestPlain
        case let .createOrUpdateProject(_, codeDefinition, testInput, textExpectedOutput): // Always send parameters as JSON in request body
            return .requestParameters(parameters: [
                "codeDefinition": codeDefinition,
                "testInput": testInput,
                "textExpectedOutput": textExpectedOutput,
            ], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    // Why is this part of the protocol??
    var sampleData: Data {
        switch self {
        case let .showProject(deviceId):
            return "{\"deviceId\": \(deviceId), \"codeDefinition\": \"(define ,A (lambda ,B ,C))\", \"testInput\": \"(append '(,g1) '(,g2))\"}, \"textExpectedOutput\": \"`(,g1 ,g2)\"}".utf8Encoded
        case let .createOrUpdateProject(deviceId, codeDefinition, testInput, textExpectedOutput):
            return "{\"deviceId\": \(deviceId), \"codeDefinition\": \"\(codeDefinition)\", \"testInput\": \"\(testInput)\"}, \"textExpectedOutput\": \"\(textExpectedOutput)\"}".utf8Encoded
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
