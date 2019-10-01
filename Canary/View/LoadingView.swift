//
//  LoadingView.swift
//  Canary
//
//  Created by Nifemi Fatoye on 28/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class LoadingView: UIView
{
    private let animatedGradientLayer = CAGradientLayer()
    
    override func layoutSubviews()
    {
        animatedGradientLayer.frame = self.frame.insetBy(dx: -frame.width, dy: -frame.height)
        animatedGradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor,UIColor.clear.cgColor]
        animatedGradientLayer.transform = CATransform3DMakeRotation(0.5 * .pi, 0, 0, 1)
        animatedGradientLayer.locations = [0,0.5,1]
        
        let shimmerAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        shimmerAnimation.duration = 1.5
        shimmerAnimation.fromValue = -2*frame.width
        shimmerAnimation.toValue = 2*frame.width
        shimmerAnimation.repeatCount = .infinity
        
        animatedGradientLayer.add(shimmerAnimation, forKey: nil)
        
        layer.mask = animatedGradientLayer
        backgroundColor = UIColor.systemGray5
    }
    
    public func stopLoading()
    {
        animatedGradientLayer.repeatCount = 1
    }
}
