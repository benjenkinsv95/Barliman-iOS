//
// Created by Ben J on 8/3/18.
// Copyright (c) 2018 Ben Jenkins. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var inputTextView: SchemeTextView!
    @IBOutlet var outputTextView: SchemeTextView!
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

        inputTextView?.textView?.delegate = self
        outputTextView?.textView?.delegate = self

        HighlightrThemeManager.instance.register(schemeTextView: inputTextView)
        HighlightrThemeManager.instance.register(schemeTextView: outputTextView)
        HighlightrThemeManager.instance.register(schemeTextView: synthesizedCode)
    }

    override func viewWillAppear(_: Bool) {
        inputTextView?.text = project.selectedTest.input
        outputTextView?.text = project.selectedTest.expectedOutput
        synthesizedCode?.text = codeSynthesizer.synthesizedCode
    }

    override func viewWillDisappear(_: Bool) {
        project.save()
    }

    @objc
    func projectUpdated(_: Notification) {
        DispatchQueue.main.async {
            self.inputTextView?.text = self.project.selectedTest.input
            self.outputTextView?.text = self.project.selectedTest.expectedOutput
        }
    }

    func textViewDidChange(_: UITextView) {
        let input = inputTextView.text
        let output = outputTextView.text
        DispatchQueue.global(qos: .background).async {
            self.project.selectedTest.input = input
            self.project.selectedTest.expectedOutput = output
        }
    }

    @objc
    func codeSynthesisChange(_ notification: Notification) {
        DispatchQueue.main.async {
            SynthesizedCodeTextViews.update(synthesizedCode: self.synthesizedCode, fromCodeSynthesis: notification)
        }
    }
}
