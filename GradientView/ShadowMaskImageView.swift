//
//  ShadowMaskImageView.swift
//  Shadows
//
//  Created by Duncan Champney on 9/7/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class ShadowMaskImageView: UIImageView {

    var isShown: Bool = true
    public  var blurRadius: Double = 2.0 {
        didSet {
            maskLayer.shadowRadius = CGFloat(blurRadius)
            setup()
        }
    }
    var maskRect = CGRect.zero
    var maskCenter = CGPoint.zero
    var maskRadius: CGFloat = 0
    public var totalDuration: Double = 3.0
    private var maskLayer = CAShapeLayer()
    private var completion: AnimationCompletion?

    public func show(_ doShow: Bool, completion: AnimationCompletion? = nil) {
        self.completion = completion
        self.alpha =  1.0


        let animation = CABasicAnimation(keyPath: "shadowPath")
        animation.duration = totalDuration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
//        animation.fromValue = maskLayer.shadowPath
        if doShow {
            animation.toValue = UIBezierPath(arcCenter: maskCenter, radius: maskRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath

        } else {
            animation.toValue = UIBezierPath(arcCenter: maskCenter, radius: 0.01, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        }
        let animationCompletion: AnimationCompletion = { finished in
            guard finished else { return }
            self.alpha = doShow ? 1.0 : 0.0
            self.isShown = doShow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.layer.removeAllAnimations()
                completion?(finished)
            }
        }
        animation.setValue(animationCompletion, forKey: animationCompletionKey)
        animation.delegate = self
        maskLayer.add(animation, forKey: nil)
    }

    func setup() {

        maskLayer.frame = self.layer.bounds
        let longest = max(maskLayer.bounds.height, maskLayer.bounds.width)
        let twoHalfLongestSquared = 2 * longest/2 * longest/2
        maskRadius = ceil(sqrt(twoHalfLongestSquared)) +  CGFloat(blurRadius) * 3

        if maskLayer.bounds.height != maskLayer.bounds.width {
            if maskLayer.bounds.height > maskLayer.bounds.width {
                let extra = maskLayer.bounds.height - maskLayer.bounds.width
                maskLayer.frame.origin.x -= extra/2
                maskLayer.bounds.size.width = maskLayer.bounds.height
            } else {
                let extra = maskLayer.bounds.width - maskLayer.bounds.height
                maskLayer.frame.origin.y -= extra/2
                maskLayer.bounds.size.height = maskLayer.bounds.width
            }
            maskLayer.bounds.size.height = longest
            maskLayer.bounds.size.width = longest
        } else {
            let offset = maskRadius - maskLayer.bounds.width/2
            maskLayer.frame.size = CGSize(width: maskRadius*2, height: maskRadius*2)
            maskLayer.frame.origin = CGPoint(x: maskLayer.frame.origin.x - offset/2, y: maskLayer.frame.origin.y - offset/2)
        }
        maskRect = maskLayer.frame
        maskCenter = CGPoint(x: maskRect.midX, y: maskRect.midY)
        let path = UIBezierPath(arcCenter: maskCenter, radius: maskRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        maskLayer.shadowPath = path.cgPath
        maskLayer.lineWidth = 2
        maskLayer.shadowColor = UIColor.black.cgColor
        maskLayer.shadowRadius = CGFloat(blurRadius)
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowOpacity = 1.0
        self.layer.mask = maskLayer
    }
    
    override func layoutSublayers(of layer: CALayer) {
        assert(layer === self.layer)
        maskLayer.frame = layer.bounds
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
