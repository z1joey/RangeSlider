//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Yi Zhang on 2020/12/11.
//  Copyright © 2020 Yi Zhang. All rights reserved.
//

import UIKit

class RangeSlider: UIView {
    private var trackView: UIView = UIView(frame: .zero)
    private var trackHighlightView: UIView = UIView(frame: .zero)
    var trackViewHeight: CGFloat = 10

    var leftThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var rightThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    var trackTintColor: UIColor = UIColor.white.withAlphaComponent(0.4)
    var trackHighlightTintColor: UIColor = .white

    var maximumValue: Double = 1.0
    var minimumValue: Double = 0.0

    // Better to set rightValue first
    var leftValue: Double = 0.0 {
        willSet {
            guard newValue <= rightValue, newValue >= minimumValue else {
                fatalError("Invalid leftValue")
            }
        }
        didSet {
            print(leftValue)
            updateLeftThumb()
            updateTrackHighlightView()
        }
    }
    var rightValue: Double = 1.0 {
        willSet {
            guard newValue >= leftValue, newValue <= maximumValue else {
                fatalError("Invalid rightValue")
            }
        }
        didSet {
            print(rightValue)
            updateRightThumb()
            updateTrackHighlightView()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        setupTrackView()
        setupThumbs()
        setupTrackHighlightView()
        setupPanGestures()
    }

    private func setupPanGestures() {
        let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftThumbPan(_:)))
        let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightThumbPan(_:)))

        leftThumb.addGestureRecognizer(leftPanGesture)
        rightThumb.addGestureRecognizer(rightPanGesture)
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
            trackHighlightView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: trackViewHeight)
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
            trackHighlightView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: trackViewHeight)
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

private extension RangeSlider {
    func setupTrackView() {
        trackView.frame = CGRect(x: 0, y: (frame.height/2 - trackViewHeight/2), width: frame.width, height: trackViewHeight)
        trackView.backgroundColor = trackTintColor
        addSubview(trackView)
    }

    func setupThumbs() {
        leftValue = minimumValue
        leftThumb.layer.cornerRadius = 10
        leftThumb.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(leftThumb)

        rightValue = maximumValue
        rightThumb.layer.cornerRadius = 10
        rightThumb.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(rightThumb)
    }

    func setupTrackHighlightView() {
        trackHighlightView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: trackViewHeight)
        trackHighlightView.backgroundColor = trackHighlightTintColor
        trackView.addSubview(trackHighlightView)
    }

    func updateLeftThumb() {
        let widthWithoutThumbs = frame.width - leftThumb.frame.width - rightThumb.frame.width
        let x = widthWithoutThumbs * CGFloat(leftValue/maximumValue)
        let y = frame.height/2 - leftThumb.frame.height/2
        print(y)
        leftThumb.frame.origin = CGPoint(x: x, y: y)
    }

    func updateRightThumb() {
        let widthWithoutThumbs = frame.width - leftThumb.frame.width - rightThumb.frame.width
        let x = leftThumb.frame.width + widthWithoutThumbs * CGFloat(rightValue/maximumValue)
        let y = frame.height/2 - rightThumb.frame.height/2
        rightThumb.frame.origin = CGPoint(x: x, y: y)
    }

    func updateTrackHighlightView() {
        trackHighlightView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: trackViewHeight)
    }
}
