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
    var tests: [Test]

    var selectedTest: Test

    // Just grab whatever the default deviceId is. /shrug
    var deviceId: String = DefaultProject.instance.deviceId

    var title: String

    var codeDefinition: String

    init(title: String, codeDefinition: String, tests: [Test]) {
        self.title = title
        self.codeDefinition = codeDefinition
        self.tests = tests
        selectedTest = tests[0]
    }

    func load() {
    }

    func save() {
    }

    func addNewTest() {
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

    // Examples from Barliman https://github.com/webyrd/Barliman/tree/master/interesting_examples
    public static func getAll() -> [SampleProject] {
        return [
            SampleProject(
                title: "New Project",
                codeDefinition: functionDefinition,
                tests: [
                    Test(id: 1,
                         input: "",
                         expectedOutput: ""),
                ]
            ),
            SampleProject(
                title: "Append",
                codeDefinition:
                """
                (define ,A
                  (lambda (lst lst2)
                    ,C))
                """,
                tests: [
                    Test(id: 1,
                         input: "(append '() '())",
                         expectedOutput: "'()"),
                    Test(id: 2,
                         input: "(append '(,g1) '(,g2))",
                         expectedOutput: "`(,g1 ,g2)"),
                    Test(id: 3,
                         input: "(append '(,g3 ,g4) '(,g5 ,g6))",
                         expectedOutput: "`(,g3 ,g4 ,g5 ,g6)"),
                ]
            ),
            SampleProject(
                title: "foldr",
                codeDefinition:
                """
                (define ,A
                  (lambda (func initialValue lst)
                    ,C))
                """,
                tests: [
                    Test(id: 1,
                         input: "(foldr ',g2 ',g1 '())",
                         expectedOutput: "`,g1"),
                    Test(id: 2,
                         input: "(foldr cons ',g4 '(,g5 ,g6))",
                         expectedOutput: "`(,g5 ,g6 . ,g4)"),
                    Test(id: 3,
                         input: "(foldr equal? ',g3 '(,g3))",
                         expectedOutput: "#t"),
                ]
            ),
        ]
    }
}
