//
//  AllTestsViewController.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/11/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import UIKit

class AllTestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var project = DefaultProject.instance
    var codeSynthesizer = DefaultCodeSynthesizer.instance
    @IBOutlet var testsTableView: UITableView!
    @IBOutlet var synthesizedCode: SchemeTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizedCode?.textView?.isEditable = false
        HighlightrThemeManager.instance.register(schemeTextView: synthesizedCode)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(codeSynthesisChange(_:)),
                                               name: .codeSynthesisCompleted,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(codeSynthesisChange(_:)),
                                               name: .codeSynthesisStarted,
                                               object: nil)
    }

    override func viewWillAppear(_ willAppear: Bool) {
        super.viewWillAppear(willAppear)
        updateUI()
    }

    func updateUI() {
        synthesizedCode?.text = codeSynthesizer.synthesizedCode
        testsTableView?.reloadData()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return project.tests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
            as! TestTableViewCell

        cell.nameLabel?.text = "\(project.tests[indexPath.row].name)"
        cell.inputTextField?.text = project.tests[indexPath.row].input
        cell.expectedOutputTextField?.text = project.tests[indexPath.row].expectedOutput

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectedTest = project.tests[indexPath.row]
        DispatchQueue.global(qos: .background).async {
            self.project.selectedTest = newSelectedTest
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "testVC") as? TestViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }

    @IBAction func addNewTest(_: Any) {
        project.addNewTest()
        updateUI()
    }

    @objc
    func codeSynthesisChange(_ notification: Notification) {
        DispatchQueue.main.async {
            SynthesizedCodeTextViews.update(synthesizedCode: self.synthesizedCode, fromCodeSynthesis: notification)
        }
    }
}
