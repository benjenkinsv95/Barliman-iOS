//
//  Project.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/5/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Moya
import SwiftyJSON
import SwiftyUserDefaults
/* Importing for access to device id. */
import UIKit

protocol Project {
    var deviceId: String { get }
    var codeDefinition: String { get set }
    var testInput: String { get set }
    // TODO: Fix typo... test, not text. This requires updating the API at this point... sigh.
    var textExpectedOutput: String { get set }

    // Don't really like these being on the Project itself. Should probably be on a ProjectPersistor
    // that takes the Project as a parameter
    func load()
    func save()
}

class DefaultProject: Project {
    // For accessing Project persistence database
    static let projectProvider = MoyaProvider<ProjectService>()
    static var instance: Project = DefaultProject()

    var deviceId: String
    var codeDefinition: String {
        didSet {
            guard oldValue != codeDefinition else {
                // Value didnt change, no need to send notification.
                return
            }
            NotificationCenter.default.post(name: .projectUpdated, object: self)
        }
    }

    var testInput: String {
        didSet {
            guard oldValue != testInput else {
                // Value didnt change, no need to send notification.
                return
            }
            NotificationCenter.default.post(name: .projectUpdated, object: self)
        }
    }

    var textExpectedOutput: String {
        didSet {
            guard oldValue != textExpectedOutput else {
                // Value didnt change, no need to send notification.
                return
            }
            NotificationCenter.default.post(name: .projectUpdated, object: self)
        }
    }

    private init() {
        guard let deviceId = UIDevice.current.identifierForVendor else {
            print("Cant find the devices id!")
            abort()
        }
        self.deviceId = deviceId.uuidString
        codeDefinition = Defaults[.definition]
        testInput = ""
        textExpectedOutput = ""
    }

    public func load() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            print("Cant find the devices id!")
            abort()
        }

        DefaultProject.projectProvider.request(ProjectService.showProject(deviceId: deviceId)) { response in
            switch response {
            case let .success(moyaResponse):
                // Must come before unwrapping JSON
                guard moyaResponse.data.toString() != "null" else {
                    print("No project exists. Default project will be used.")
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

                guard let codeDefinition = projectJson["codeDefinition"].string,
                    let testInput = projectJson["testInput"].string,
                    let textExpectedOutput = projectJson["textExpectedOutput"].string
                else {
                    assertionFailure("Couldn't extract fields from JSON. Maybe the API changed?")
                    abort()
                }

                self.codeDefinition = codeDefinition
                self.testInput = testInput
                self.textExpectedOutput = textExpectedOutput
                print("Succesfully loaded project")
            case let .failure(error):
                assertionFailure("Error when attempting to load project: \(error)")
            }
        }
    }

    public func save() {
        DefaultProject.projectProvider.request(ProjectService.createOrUpdateProject(deviceId: deviceId, codeDefinition: codeDefinition, testInput: testInput, textExpectedOutput: textExpectedOutput)) { response in
            switch response {
            case let .success(success):
                print("Save succesful!")
                print(success.data.toString())
            case let .failure(error):
                print("Failed to save project \(error)")
            }
        }
    }
}
