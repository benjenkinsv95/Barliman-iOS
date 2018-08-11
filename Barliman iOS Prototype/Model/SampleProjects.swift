//
//  SampleProjects.swift
//  Barliman iOS Prototype
//
//  Someday it would be cool to load projects from a database. But for now, here are some canned projects.
//
//  Created by Ben J on 8/7/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation

class SampleProject: Project {
    // Just grab whatever the default deviceId is. /shrug
    var deviceId: String = DefaultProject.instance.deviceId

    var title: String

    var codeDefinition: String

    var testInput: String

    var textExpectedOutput: String

    init(title: String, codeDefinition: String, testInput: String, textExpectedOutput: String) {
        self.title = title
        self.codeDefinition = codeDefinition
        self.testInput = testInput
        self.textExpectedOutput = textExpectedOutput
    }

    func load() {
    }

    func save() {
    }
}

class SampleProjects {
    public static let functionDefinition =
        """
        ; Define functions below.
        ; Leave holes in your functions with
        ; single letter capital variable names
        ; (e.g. ,A ,B ,C etc..)

        ; Holes in the example below
        ; ,A will be the functions name
        ; ,B will be the function's parameters
        ; ,C will be the function's body

        (define ,A
          (lambda ,B
            ,C
          )
        )
        """

    public static func getAll() -> [SampleProject] {
        return [
            SampleProject(
                title: "Append (2 empty lists)",
                codeDefinition: functionDefinition,
                testInput: "(append '() '())",
                textExpectedOutput: "`()"
            ),
            SampleProject(
                title: "Append (2 single element number lists)",
                codeDefinition: functionDefinition,
                testInput: "(append '(1) '(2))",
                textExpectedOutput: "`(1 2)"
            ),
            SampleProject(
                title: "Append (2 single element lists)",
                codeDefinition: functionDefinition,
                testInput: "(append '(,g1) '(,g2))",
                textExpectedOutput: "`(,g1 ,g2)"
            ),
            SampleProject(
                title: "Append (2 lists with 2 elements each)",
                codeDefinition: functionDefinition,
                testInput: "(append '(,g3 ,g4) '(,g5 ,g6))",
                textExpectedOutput: "`(,g3 ,g4 ,g5 ,g6)"
            ),
            SampleProject(
                title: "foldr (with cons)",
                codeDefinition: functionDefinition,
                testInput: "(foldr cons ',g4 '(,g5 ,g6))",
                textExpectedOutput: "`(,g5 ,g6 ,g4)"
            ),
            SampleProject(
                title: "foldr (with equal)",
                codeDefinition: functionDefinition,
                testInput: "(foldr equal? ',g3 '(,g3))",
                textExpectedOutput: "#t"
            ),
        ]
    }
}
