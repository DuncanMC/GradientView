//
//  RadialMaskedImageView.swift
//  GradientView
//
//  Created by Duncan Champney on 9/3/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class RadialMaskedImageView: UIImageView {

    let maskLayer = CAGradientLayer()

    public func show(doShow: Bool) {

        self.alpha =  1.0

        let stepDuration = 0.15


        let startingColors  = doShow ?
            [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
        ] : [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
        ]

        let middleColors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor,
        ]
        let endingColors = doShow ?
                [
                UIColor.black.cgColor,
                UIColor.black.cgColor,
            ] :
                [
                UIColor.clear.cgColor,
                UIColor.clear.cgColor,
            ]

        //Create another animation group to animate both image layers back to their starting position
        let group = CAAnimationGroup()
        group.duration = stepDuration * 2

        //Have the return animation begin after a short pause
        //            group.beginTime = CACurrentMediaTime() + 0.2

        //Animate the right foot back to its original position
        let firstStep = CABasicAnimation(keyPath: "colors")
        firstStep.fillMode = .forwards
        firstStep.fromValue = startingColors
        firstStep.toValue = middleColors
        firstStep.duration = stepDuration
        group.animations = [firstStep]

        //Animate the left foot back to its original position at the same time
        let secondStep = CABasicAnimation(keyPath: "colors")
        secondStep.fillMode = .forwards
        secondStep.fromValue = middleColors
        secondStep.toValue = endingColors
        secondStep.beginTime = stepDuration * 1
        secondStep.duration = stepDuration

        //In the completion block, remove all animations and re-enable the animate button.
        let animationCompletion: AnimationCompletion = { finished in
            guard finished else { return }
            self.alpha = doShow ? 1.0 : 0.0
            self.layer.removeAllAnimations()
        }

        firstStep.delegate = self

        group.animations?.append(secondStep)
        group.delegate = self

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
            ]
            maskLayer.locations = [0,1]
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
