//
//  AllTestsViewController.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 8/11/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import UIKit

class AllTestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let project = DefaultProject.instance

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 6 // TODO: the number of tests
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
            as! TestTableViewCell

        cell.nameLabel?.text = "Test \(indexPath.row + 1)"
        cell.inputTextField?.text = project.testInput
        cell.expectedOutputTextField?.text = project.textExpectedOutput

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
    }
}
