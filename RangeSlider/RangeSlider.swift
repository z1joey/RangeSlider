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

    public var trackViewHeight: CGFloat = 4 {
        didSet {
            updateTrackViewFrame()
            updateTrackHighlightViewFrame()
        }
    }

    var leftThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) {
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
            updateTrackHighlightViewFrame()
        }
    }
    var rightThumb: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) {
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
            updateTrackHighlightViewFrame()
        }
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
    private var gapBetweenThumbs: CGFloat {
        return frame.width - leftThumb.frame.width - rightThumb.frame.width
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

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateTrackViewFrame()
        updateLeftThumbOrigin()
        updateRightThumbOrigin()
        updateTrackHighlightViewFrame()
    }

    private func commonInit() {
        backgroundColor = .clear
        addTrackView()
        addThumbs()
        addTrackHighlightView()
    }

    private func addThumbs() {
        leftThumb.layer.cornerRadius = leftThumb.frame.width/2
        leftThumb.backgroundColor = .white
        leftThumb.applyShadowWithCornerRadius(color: .black, opacity: 0.4, radius: leftThumb.frame.height/2, edge: .All, shadowSpace: 2)

        rightThumb.layer.cornerRadius = leftThumb.frame.width/2
        rightThumb.backgroundColor = .white
        rightThumb.applyShadowWithCornerRadius(color: .black, opacity: 0.4, radius: leftThumb.frame.height/2, edge: .All, shadowSpace: 2)

        addSubview(leftThumb)
        addSubview(rightThumb)

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
            print(leftThumbMaxX)
            delegate?.rangeSliderDidBeganUpdatingValues(self)
        case .changed:
            leftValue = Double((leftThumbMaxX - leftThumb.frame.width + translation.x)/gapBetweenThumbs) * gapBetweenMaxAndMin
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
            rightValue = Double((rightThumbMinX - leftThumb.frame.width + translation.x)/gapBetweenThumbs) * gapBetweenMaxAndMin
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
        trackView.layer.cornerRadius = trackView.frame.height/2
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
        var targetX = gapBetweenThumbs * percentage + leftThumb.frame.width
        //print("\(percentage): \(targetX)")
        if targetX > rightThumb.frame.minX {
            targetX = rightThumb.frame.minX
        }

        let leftThumbX = targetX - leftThumb.frame.width
        let leftThumbY = frame.height/2 - leftThumb.frame.height/2

        leftThumb.frame.origin = CGPoint(x: leftThumbX, y: leftThumbY)
    }

    func updateRightThumbOrigin() {
        let percentage = CGFloat((rightValue - minimumValue) / gapBetweenMaxAndMin)
        var targetX = gapBetweenThumbs * percentage + leftThumb.frame.width

        if targetX < leftThumb.frame.maxX {
            targetX = leftThumb.frame.maxX
        }

        let rightThumbX = targetX
        let rightThumbY = frame.height/2 - leftThumb.frame.height/2

        rightThumb.frame.origin = CGPoint(x: rightThumbX, y: rightThumbY)
    }
}

private extension UIView {
    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)    {

        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)


        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)


        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true;

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }

    enum AIEdge:Int {
        case
        Top,
        Left,
        Bottom,
        Right,
        Top_Left,
        Top_Right,
        Bottom_Left,
        Bottom_Right,
        All,
        None
    }
}
