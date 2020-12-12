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
            updateTrackView()
            updateTrackHighlightView()
        }
    }

    var leftThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var rightThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    public var trackTintColor: UIColor = UIColor.white.withAlphaComponent(0.4)
    public var trackHighlightTintColor: UIColor = .white

    public var maximumValue: Double = 1.0 {
        didSet { rightValue = maximumValue }
    }
    public var minimumValue: Double = 0.0 {
        didSet { leftValue = minimumValue }
    }

    // Better to set rightValue first
    public var leftValue: Double = 0.0 {
        didSet {
            if leftValue > rightValue {
                leftValue = rightValue
            } else if leftValue < minimumValue {
                leftValue = minimumValue
            }

            updateLeftThumb()
            updateTrackHighlightView()
        }
    }
    public var rightValue: Double = 1.0 {
        didSet {
            if rightValue < leftValue {
                rightValue = leftValue
            } else if rightValue > maximumValue {
                rightValue = maximumValue
            }

            updateRightThumb()
            updateTrackHighlightView()
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

    private var leftThumbMaxX: CGFloat = 0

    @objc func handleLeftThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .began:
            leftThumbMaxX = leftThumb.frame.maxX
            delegate?.rangeSliderDidBeganUpdatingValues(self)
        case .changed:
            let widthWithoutThumbs = frame.width - leftThumb.frame.width - rightThumb.frame.width
            leftValue = Double((leftThumbMaxX + translation.x)/widthWithoutThumbs) * maximumValue
            delegate?.rangeSliderIsUpdatingValues(self)
        case .cancelled, .ended:
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
            let widthWithoutThumbs = frame.width - leftThumb.frame.width - rightThumb.frame.width
            rightValue = Double((rightThumbMinX + translation.x)/widthWithoutThumbs) * maximumValue
            delegate?.rangeSliderIsUpdatingValues(self)
        case .cancelled, .ended:
            //rightThumbMinX = rightThumb.frame.minX
            gesture.setTranslation(.zero, in: self)
            delegate?.rangeSliderDidEndUpdatingValues(self)
        default:
            break
        }
    }
}

private extension RangeSlider {
    func setupTrackView() {
        updateTrackView()
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
        updateTrackHighlightView()
        trackHighlightView.backgroundColor = trackHighlightTintColor
        trackView.addSubview(trackHighlightView)
    }

    func updateTrackView() {
        trackView.frame = CGRect(x: 0, y: (frame.height/2 - trackViewHeight/2), width: frame.width, height: trackViewHeight)
    }

    func updateTrackHighlightView() {
        trackHighlightView.frame = CGRect(x: leftThumb.center.x, y: 0, width: rightThumb.center.x - leftThumb.center.x, height: trackViewHeight)
    }

    func updateLeftThumb() {
        let widthWithoutThumbs = frame.width - leftThumb.frame.width - rightThumb.frame.width
        let x = widthWithoutThumbs * CGFloat(leftValue/maximumValue)
        let y = frame.height/2 - leftThumb.frame.height/2
        leftThumb.frame.origin = CGPoint(x: x, y: y)
    }

    func updateRightThumb() {
        let widthWithoutThumbs = frame.width - leftThumb.frame.width - rightThumb.frame.width
        let x = leftThumb.frame.width + widthWithoutThumbs * CGFloat(rightValue/maximumValue)
        let y = frame.height/2 - rightThumb.frame.height/2
        rightThumb.frame.origin = CGPoint(x: x, y: y)
    }
}
