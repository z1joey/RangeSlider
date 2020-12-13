//
//  ViewController.swift
//  RangeSlider
//
//  Created by Yi Zhang on 2020/12/11.
//  Copyright © 2020 Yi Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RangeSliderDelegate {
    @IBOutlet weak var rangeSlider1: RangeSlider!
    @IBOutlet weak var rangeSlider2: RangeSlider!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        rangeSlider1.maximumValue = 5
        rangeSlider1.minimumValue = 1
        rangeSlider1.delegate = self

        rangeSlider2.maximumValue = 1000
        rangeSlider2.minimumValue = 1
        rangeSlider2.delegate = self
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

