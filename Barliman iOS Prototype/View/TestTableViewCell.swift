//
//  TestTableViewCell.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/11/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var inputTextField: SchemeTextView! {
        didSet {
            inputTextField?.textView?.isSelectable = false
            inputTextField?.isUserInteractionEnabled = false
            HighlightrThemeManager.instance.register(schemeTextView: inputTextField)
        }
    }

    @IBOutlet var expectedOutputTextField: SchemeTextView! {
        didSet {
            expectedOutputTextField?.textView?.isSelectable = false
            expectedOutputTextField?.isUserInteractionEnabled = false
            HighlightrThemeManager.instance.register(schemeTextView: expectedOutputTextField)
        }
    }
}
