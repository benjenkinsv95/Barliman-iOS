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
    }

    override func viewWillAppear(_: Bool) {
        inputTextView?.text = project.testInput
        outputTextView?.text = project.textExpectedOutput
        synthesizedCode?.text = codeSynthesizer.synthesizedCode
    }

    override func viewWillDisappear(_: Bool) {
        project.save()
    }

    @objc
    func projectUpdated(_: Notification) {
        DispatchQueue.main.async {
            self.inputTextView?.text = self.project.testInput
            self.outputTextView?.text = self.project.textExpectedOutput
        }
    }

    func textViewDidChange(_: UITextView) {
        project.testInput = inputTextView.text
        project.textExpectedOutput = outputTextView.text
    }

    @objc
    func codeSynthesisChange(_ notification: Notification) {
        DispatchQueue.main.async {
            SynthesizedCodeTextViews.update(synthesizedCode: self.synthesizedCode, fromCodeSynthesis: notification)
        }
    }

    @IBAction func loadPressed(_: Any) {
        SampleProjectPopupLoader.load()
    }
}
