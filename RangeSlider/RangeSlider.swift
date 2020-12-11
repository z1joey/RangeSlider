//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Yi Zhang on 2020/12/11.
//  Copyright © 2020 Yi Zhang. All rights reserved.
//

import UIKit

class RangeSlider: UIView, NibLoadable {
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var leftThumb: UIView!
    @IBOutlet weak var rightThumb: UIView!

    @IBOutlet weak var leftThumbLeading: NSLayoutConstraint!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib(owner: self)
        backgroundColor = .clear
    }

    @IBAction func handleLeftThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .began:
            print("began")
        case .changed:
            print("changed")
            let targetX = leftThumb.center.x + translation.x
            print(targetX)
            let finalX =
                max(min(min(targetX, (rightThumb.center.x - rightThumb.frame.width)), (bounds.width - leftThumb.bounds.width/2)), leftThumb.frame.width/2)
            let newCenter = CGPoint(x: finalX, y: leftThumb.center.y)
            leftThumb.center = newCenter
            gesture.setTranslation(.zero, in: self)
        case .cancelled, .ended:
            print("finished")
            gesture.setTranslation(.zero, in: self)
        default:
            print(gesture.state)
            break
        }
    }

    @IBAction func handleRightThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .began:
            print("began")
        case .changed:
            print("changed")
            let targetX = rightThumb.center.x + translation.x
            print(targetX)
            let finalX =
                max(min(max(targetX, (leftThumb.center.x + leftThumb.frame.width)), (bounds.width - leftThumb.bounds.width/2)), leftThumb.frame.width/2)
            let newCenter = CGPoint(x: finalX, y: leftThumb.center.y)
            rightThumb.center = newCenter
            gesture.setTranslation(.zero, in: self)
        case .cancelled, .ended:
            print("finished")
            gesture.setTranslation(.zero, in: self)
        default:
            print(gesture.state)
            break
        }
    }
}
