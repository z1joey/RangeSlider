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
        let thumb1 = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        thumb1.alpha = 0.5
        thumb1.backgroundColor = .black
        thumb1.layer.cornerRadius = 22

        let thumb2 = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        thumb2.alpha = 0.5
        thumb2.backgroundColor = .black
        thumb2.layer.cornerRadius = 22

        rangeSlider.maximumValue = 5
        rangeSlider.minimumValue = 1
        rangeSlider.leftThumb = thumb1
        rangeSlider.rightThumb = thumb2
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

