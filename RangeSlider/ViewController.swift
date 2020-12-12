//
//  ViewController.swift
//  RangeSlider
//
//  Created by Yi Zhang on 2020/12/11.
//  Copyright © 2020 Yi Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RangeSliderDelegate {
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rangeSlider.maximumValue = 100
        rangeSlider.minimumValue = 0
        rangeSlider.delegate = self
    }

    func rangeSliderIsUpdatingValues(_ slider: RangeSlider) {
        leftLabel.text = String(slider.leftValue.rounded())
        rightLabel.text = String(slider.rightValue.rounded())
    }

    func rangeSliderDidBeganUpdatingValues(_ slider: RangeSlider) {
        print("began")
    }

    func rangeSliderDidEndUpdatingValues(_ slider: RangeSlider) {
        print("end")
    }
}

