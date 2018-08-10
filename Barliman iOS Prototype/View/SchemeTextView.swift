//
//  SchemeTextView.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 7/31/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import Highlightr
import UIKit

class SchemeTextView: UIView {
    var textView: UITextView?

    var text: String {
        set {
            guard textView?.text != newValue else {
                // Value are the same. No need to set it again.
                return
            }
            textView?.text = newValue
        }
        get { return textView?.text ?? "" }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initTextView(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTextView(frame: self.frame)
    }

    func initTextView(frame _: CGRect) {
        let textStorage = CodeAttributedString()
        textStorage.language = "Scheme"
        textStorage.highlightr.setTheme(to: "Pojoaque")
        textStorage.highlightr.theme.codeFont = RPFont(name: "Courier", size: 14)

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: self.bounds.size)
        layoutManager.addTextContainer(textContainer)

        textView = UITextView(frame: self.bounds, textContainer: textContainer)
        textView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView?.autocorrectionType = UITextAutocorrectionType.no
        textView?.autocapitalizationType = UITextAutocapitalizationType.none
        textView?.backgroundColor = textStorage.highlightr.theme.themeBackgroundColor

        self.addSubview(textView!)
    }
}
