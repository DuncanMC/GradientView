//
//  ViewController.swift
//  GradientView
//
//  Created by Duncan Champney on 9/3/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var maskedView: RadialMaskedImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func handleShowImageSwitch(_ sender: UISwitch) {
        let value = sender.isOn
        sender.isEnabled = false
        maskedView.show(doShow: value) { _ in
            sender.isEnabled = true
        }
    }

}

