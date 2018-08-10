//
//  DefinitionView.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/3/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import SwiftyUserDefaults
import UIKit

class DefinitionViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var definitionView: SchemeTextView!
    @IBOutlet var synthesizedCode: SchemeTextView!
    var project = DefaultProject.instance
    var codeSynthesizer = DefaultCodeSynthesizer.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizedCode?.textView?.isEditable = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(projectUpdated(_:)),
                                               name: .projectUpdated,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(codeSynthesisChange(_:)),
                                               name: .codeSynthesisCompleted,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(codeSynthesisChange(_:)),
                                               name: .codeSynthesisStarted,
                                               object: nil)

        definitionView?.textView?.delegate = self
        HighlightrThemeManager.instance.register(schemeTextView: definitionView)
        HighlightrThemeManager.instance.register(schemeTextView: synthesizedCode)
    }

    override func viewWillAppear(_: Bool) {
        definitionView?.text = project.codeDefinition
        synthesizedCode?.text = codeSynthesizer.synthesizedCode
    }

    override func viewWillDisappear(_: Bool) {
        project.save()
    }

    @objc
    func projectUpdated(_: Notification) {
        DispatchQueue.main.async {
            self.definitionView?.text = self.project.codeDefinition
        }
    }

    @objc
    func codeSynthesisChange(_ notification: Notification) {
        DispatchQueue.main.async {
            SynthesizedCodeTextViews.update(synthesizedCode: self.synthesizedCode, fromCodeSynthesis: notification)
        }
    }

    func textViewDidChange(_: UITextView) {
        project.codeDefinition = definitionView.text
    }

    @IBAction func loadPressed(_: Any) {
        SampleProjectPopupLoader.load()
    }
}
