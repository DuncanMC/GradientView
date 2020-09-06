//
//  RadialMaskedImageView.swift
//  GradientView
//
//  Created by Duncan Champney on 9/3/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class RadialMaskedImageView: UIImageView {
    public var totalDuration: Double = .25
    public var blurPercent: Double = 0.2
    public var midStepDelay: Double = 0

    private var completion: AnimationCompletion?
    private let maskLayer = CAGradientLayer()

    public func show(doShow: Bool, completion: AnimationCompletion? = nil) {

        self.completion = completion
        self.alpha =  1.0


        let group = CAAnimationGroup()
        group.duration = totalDuration + midStepDelay




        let firstStep = CABasicAnimation(keyPath: "locations")
        let firstStepStartingValue: [Double] = doShow ? [0, 0, 0] : [1, 1, 1.0 + blurPercent]
        let firstStepEndingValue: [Double] = [0, 0, blurPercent]

        firstStep.fillMode = .forwards
        firstStep.fromValue = firstStepStartingValue
        firstStep.toValue = firstStepEndingValue
        let firstStepPercent = doShow ? blurPercent : 1.0 - blurPercent
        firstStep.duration = totalDuration * firstStepPercent

        group.animations = [firstStep]

        let secondStep = CABasicAnimation(keyPath: "locations")
        let secondStepStartingValue: [Double] =  [0, 0, blurPercent]

        let secondStepEndingValue: [Double] = doShow ? [1, 1, 1.0 + blurPercent] : [0, 0, 0]

        secondStep.fillMode = .forwards
        secondStep.fromValue = secondStepStartingValue
        secondStep.toValue = secondStepEndingValue
        let secondStepPercent = doShow ? 1.0 - blurPercent : blurPercent
        secondStep.duration = totalDuration * secondStepPercent
        secondStep.beginTime = firstStep.duration + midStepDelay
        //In the completion block, remove all animations and re-enable the animate button.
        let animationCompletion: AnimationCompletion = { finished in
            guard finished else { return }
            self.alpha = doShow ? 1.0 : 0.0
            self.layer.removeAllAnimations()
            completion?(finished)
        }


        group.animations?.append(secondStep)
        group.delegate = self
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        //Attach a completion block to the group animation
        group.setValue(animationCompletion, forKey: animationCompletionKey)

        maskLayer.add(group, forKey: nil)
    }

        func setup() {
            maskLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            maskLayer.endPoint = CGPoint(x: 1.2, y: 1.2)
            maskLayer.type = .radial

            //Opaque mask shows the image.
            maskLayer.colors = [
                UIColor.black.cgColor,
                UIColor.black.cgColor,
            UIColor.clear.cgColor,
            ]
            maskLayer.locations = [0, 1, 1]
//            self.layer.addSublayer(maskLayer)
            self.layer.mask = maskLayer

        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        override func layoutSublayers(of layer: CALayer) {
            assert(layer === self.layer)
            maskLayer.frame = layer.bounds
        }
}
