//
//  ViewController.swift
//  Barliman iOS Prototype
//
//  Created by Ben J on 7/26/18.
//  Copyright © 2018 Ben Jenkins. All rights reserved.
//

import UIKit

class ProjectController: UITabBarController, UIGestureRecognizerDelegate {
    var codeSynthesizer = DefaultCodeSynthesizer.instance
    var project = DefaultProject.instance
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(projectUpdated(_:)),
                                               name: .projectUpdated,
                                               object: nil)
    }

    @objc
    func projectUpdated(_: Notification) {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(self.synthesizeCode(_:)), userInfo: nil, repeats: false)
        }
    }

    @objc func synthesizeCode(_: Timer) {
        codeSynthesizer.synthesize()
    }
}
