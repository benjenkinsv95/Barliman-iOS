//
//  LoadSampleProjectPopup.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/7/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Foundation
import TCPickerView
import UIKit

class SampleProjectPopupLoader {
    static var project = DefaultProject.instance

    static func load() {
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Load Project"
        let sampleProjects = SampleProjects.getAll()
        picker.values = sampleProjects.map { TCPickerView.Value(title: $0.title) }
        picker.theme = TCPickerViewLightTheme()
        picker.selection = .single
        picker.completion = { selectedIndexes in
            guard !selectedIndexes.isEmpty else {
                print("No value selected.")
                return
            }

            let selectedIndex = selectedIndexes[0]
            let selectedProject = sampleProjects[selectedIndex]
            print("Selected \(selectedProject.title)")
            self.project.codeDefinition = selectedProject.codeDefinition
            self.project.tests = selectedProject.tests
            self.project.selectedTest = selectedProject.selectedTest
        }
        picker.show()
    }
}
