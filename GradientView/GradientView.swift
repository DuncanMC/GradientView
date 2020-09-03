//
//  GradientView.swift
//  GradientView
//
//  Created by Duncan Champney on 9/3/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()

    func setup() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.2, y: 1.2)
//        gradientLayer.locations = [
//            0,
//            0.9,
//            1
//        ]
        gradientLayer.type = .radial
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor,
        ]
        self.layer.addSublayer(gradientLayer)

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
        gradientLayer.frame = layer.bounds
    }
}
