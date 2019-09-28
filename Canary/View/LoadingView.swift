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
        animatedGradientLayer.locations = [0,0.5,1]
        
        let shimmerAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        shimmerAnimation.duration = 3
        shimmerAnimation.fromValue = -3*frame.height
        shimmerAnimation.toValue = 2*frame.height
        shimmerAnimation.repeatCount = .infinity
        
        animatedGradientLayer.add(shimmerAnimation, forKey: nil)
        
        layer.mask = animatedGradientLayer
    }
    
    public func stopLoading()
    {
        animatedGradientLayer.repeatCount = 1
    }
}
