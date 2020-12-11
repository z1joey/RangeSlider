//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Yi Zhang on 2020/12/11.
//  Copyright © 2020 Yi Zhang. All rights reserved.
//

import UIKit

class RangeSlider: UIView, NibLoadable {
    @IBOutlet weak var untrackView: UIView!
    @IBOutlet weak var leftThumb: UIView!
    @IBOutlet weak var rightThumb: UIView!

    var trackView: UIView = UIView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib(owner: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        trackView.backgroundColor = .green
        trackView.frame = untrackView.bounds
        untrackView.addSubview(trackView)
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
            trackView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: untrackView.frame.height)
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
            trackView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: untrackView.frame.height)
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
