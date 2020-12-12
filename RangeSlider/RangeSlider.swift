//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Yi Zhang on 2020/12/11.
//  Copyright © 2020 Yi Zhang. All rights reserved.
//

import UIKit

public protocol RangeSliderDelegate: class {
    func rangeSliderDidBeganUpdatingValues(_ slider: RangeSlider)
    func rangeSliderDidEndUpdatingValues(_ slider: RangeSlider)
    func rangeSliderIsUpdatingValues(_ slider: RangeSlider)
}

public class RangeSlider: UIView {
    private var trackView: UIView = UIView(frame: .zero)
    private var trackHighlightView: UIView = UIView(frame: .zero)

    public var trackViewHeight: CGFloat = 10 {
        didSet {
            updateTrackViewFrame()
            updateTrackHighlightViewFrame()
        }
    }

    var leftThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) {
        willSet {
            leftThumb.removeFromSuperview()
            leftPanGesture?.removeTarget(self, action: #selector(handleLeftThumbPan(_:)))
            leftPanGesture = nil
        }
        didSet {
            addSubview(leftThumb)
            updateLeftThumbOrigin()
            updateRightThumbOrigin()
            addLeftThumbPanGesture()
        }
    }
    var rightThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) {
        willSet {
            rightThumb.removeFromSuperview()
            rightPanGesture?.removeTarget(self, action: #selector(handleRightThumbPan(_:)))
            rightPanGesture = nil
        }
        didSet {
            addSubview(rightThumb)
            updateRightThumbOrigin()
            updateLeftThumbOrigin()
            addRightThumbPanGesture()
        }
    }

    var safeWidth: CGFloat {
        return frame.width - leftThumb.frame.width - rightThumb.frame.width
    }

    private var leftPanGesture: UIPanGestureRecognizer?
    private var rightPanGesture: UIPanGestureRecognizer?

    public var trackTintColor: UIColor = UIColor.white.withAlphaComponent(0.4)
    public var trackHighlightTintColor: UIColor = .white

    public var maximumValue: Double = 1.0 {
        didSet { rightValue = maximumValue }
    }
    public var minimumValue: Double = 0.0 {
        didSet { leftValue = minimumValue }
    }
    private var gapBetweenMaxAndMin: Double {
        return maximumValue - minimumValue
    }

    // Better to set rightValue first
    public var leftValue: Double = 0.0 {
        didSet {
            if leftValue > rightValue {
                leftValue = rightValue
            } else if leftValue < minimumValue {
                leftValue = minimumValue
            }

            updateLeftThumbOrigin()
            updateTrackHighlightViewFrame()
        }
    }
    
    public var rightValue: Double = 1.0 {
        didSet {
            if rightValue < leftValue {
                rightValue = leftValue
            } else if rightValue > maximumValue {
                rightValue = maximumValue
            }

            updateRightThumbOrigin()
            updateTrackHighlightViewFrame()
        }
    }

    public weak var delegate: RangeSliderDelegate?

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
        addTrackView()
        addSubview(leftThumb)
        addSubview(rightThumb)
        addTrackHighlightView()
        addLeftThumbPanGesture()
        addRightThumbPanGesture()
    }

    private func addLeftThumbPanGesture() {
        leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftThumbPan(_:)))
        leftThumb.addGestureRecognizer(leftPanGesture!)
    }
    private func addRightThumbPanGesture() {
        rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightThumbPan(_:)))
        rightThumb.addGestureRecognizer(rightPanGesture!)
    }

    private var leftThumbMaxX: CGFloat = 0

    @objc func handleLeftThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .began:
            leftThumbMaxX = leftThumb.frame.maxX
            delegate?.rangeSliderDidBeganUpdatingValues(self)
        case .changed:
            leftValue = Double((leftThumbMaxX + translation.x)/safeWidth) * gapBetweenMaxAndMin
            delegate?.rangeSliderIsUpdatingValues(self)
        case .cancelled, .ended:
            leftThumbMaxX = leftThumb.frame.maxX
            gesture.setTranslation(.zero, in: self)
            delegate?.rangeSliderDidEndUpdatingValues(self)
        default:
            break
        }
    }

    private var rightThumbMinX: CGFloat = 0

    @objc func handleRightThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .began:
            rightThumbMinX = rightThumb.frame.minX
            delegate?.rangeSliderDidBeganUpdatingValues(self)
        case .changed:
            rightValue = Double((rightThumbMinX - leftThumb.frame.width + translation.x)/safeWidth) * gapBetweenMaxAndMin
            delegate?.rangeSliderIsUpdatingValues(self)
        case .cancelled, .ended:
            rightThumbMinX = rightThumb.frame.minX
            gesture.setTranslation(.zero, in: self)
            delegate?.rangeSliderDidEndUpdatingValues(self)
        default:
            break
        }
    }
}

private extension RangeSlider {
    func addTrackView() {
        updateTrackViewFrame()
        trackView.backgroundColor = trackTintColor
        addSubview(trackView)
    }

    func addTrackHighlightView() {
        updateTrackHighlightViewFrame()
        trackHighlightView.backgroundColor = trackHighlightTintColor
        trackView.addSubview(trackHighlightView)
    }

    func updateTrackViewFrame() {
        trackView.frame = CGRect(x: 0, y: (frame.height/2 - trackViewHeight/2), width: frame.width, height: trackViewHeight)
    }

    func updateTrackHighlightViewFrame() {
        trackHighlightView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: trackViewHeight)
    }

    func updateLeftThumbOrigin() {
        let percentage = CGFloat((leftValue - minimumValue) / gapBetweenMaxAndMin)
        var targetX = leftThumb.frame.width + (safeWidth * percentage)

        if targetX > rightThumb.frame.minX {
            targetX = rightThumb.frame.minX
        }

        let leftThumbX = targetX - leftThumb.frame.width
        let leftThumbY = frame.height/2 - leftThumb.frame.height/2

        leftThumb.frame.origin = CGPoint(x: leftThumbX, y: leftThumbY)
    }

    func updateRightThumbOrigin() {
        let percentage = CGFloat((rightValue - minimumValue) / gapBetweenMaxAndMin)
        var targetX = safeWidth * percentage + leftThumb.frame.width

        if targetX < leftThumb.frame.maxX {
            targetX = leftThumb.frame.maxX
        }

        let rightThumbX = targetX
        let rightThumbY = frame.height/2 - leftThumb.frame.height/2

        rightThumb.frame.origin = CGPoint(x: rightThumbX, y: rightThumbY)
    }
}
