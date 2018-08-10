//
//  SettingsViewController.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/10/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import SwiftyUserDefaults
import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var themePicker: UIPickerView!
    @IBOutlet var schemeThemeExampleTextView: SchemeTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        schemeThemeExampleTextView.text = Defaults[.definition]
        HighlightrThemeManager.instance.register(schemeTextView: schemeThemeExampleTextView)
        let row = HighlightrThemeManager.instance.allThemes.index(of: HighlightrThemeManager.instance.theme.lowercased())
        themePicker.selectRow(row!, inComponent: 0, animated: false)
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return HighlightrThemeManager.instance.allThemes.count
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        let theme = HighlightrThemeManager.instance.allThemes[row]
        HighlightrThemeManager.instance.setTheme(theme)
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return HighlightrThemeManager.instance.allThemes[row]
    }
}
