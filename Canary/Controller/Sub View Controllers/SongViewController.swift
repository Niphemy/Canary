//
//  SongViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 23/11/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class SongViewController: UIViewController
{
    private let superTabViewController : TabViewController
    private var heightAnchor : NSLayoutConstraint?
    private var bottomAnchor : NSLayoutConstraint?
    private let swipeBuffer : CGFloat = 50
    private var viewMode : ViewMode = .contracted
    {
        didSet
        {
            if viewMode == .expanded && oldValue == .contracted
            {
                UIView.animate(withDuration: 0.2)
                {
                    self.superTabViewController.tabBar.alpha = 0
                    self.bottomAnchor?.constant = self.superTabViewController.tabBar.frame.height
                }
            }
            else if viewMode == .contracted && oldValue == .expanded
            {
                UIView.animate(withDuration: 0.2)
                {
                    self.superTabViewController.tabBar.alpha = 1
                    self.bottomAnchor?.constant = 0
                }
            }
        }
    }
    
    var maxSafeViewHeight : CGFloat
    {
        let statusBarHeight = view.window!.windowScene!.statusBarManager!.statusBarFrame.height
        let tabBarHeight = superTabViewController.tabBar.frame.height
        return (superTabViewController.view.frame.height - (tabBarHeight + statusBarHeight))
    }
    
    enum ViewMode
    {
        case contracted
        case expanded
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(superTabViewController : TabViewController)
    {
        self.superTabViewController = superTabViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    public func setAnimatedConstraints(heightAnchor: NSLayoutConstraint, bottomAnchor: NSLayoutConstraint)
    {
        self.heightAnchor = heightAnchor
        self.bottomAnchor = bottomAnchor
        
        self.heightAnchor?.isActive = true
        self.bottomAnchor?.isActive = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicCellColor
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 15
        view.backgroundColor = .globalTintColor
    }
    
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        let translation = gestureRecognizer.translation(in: superTabViewController.view)
        guard let heightAnchor = heightAnchor else { fatalError("Height anchor has not been set") }
        
        var newHeight = heightAnchor.constant - translation.y
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed
        {
            if newHeight > maxSafeViewHeight
            {
                newHeight = maxSafeViewHeight
            }else if newHeight < 0
            {
                newHeight = 0
            }
            
            heightAnchor.constant = newHeight
            
            gestureRecognizer.setTranslation(CGPoint.zero, in: superTabViewController.view)
        }
        
        if gestureRecognizer.state == .ended
        {
            if newHeight > swipeBuffer && viewMode == .contracted
            {
                fullyExpandView()
            }
            else if newHeight < swipeBuffer && viewMode == .contracted
            {
                fullyContractView()
            }
            else if newHeight < maxSafeViewHeight - swipeBuffer && viewMode == .expanded
            {
                fullyContractView()
            }
            else if newHeight > maxSafeViewHeight - swipeBuffer && viewMode == .expanded
            {
                fullyExpandView()
            }
        }
    }
    
    // MARK: - Navigation
    
    // MARK: - Animation
    
    func fullyExpandView()
    {
        heightAnchor?.constant = maxSafeViewHeight
        viewMode = .expanded
        UIView.animate(withDuration: 0.2)
        {
            self.superTabViewController.view.layoutIfNeeded()
        }
    }
    
    func fullyContractView()
    {
        heightAnchor?.constant = 0
        viewMode = .contracted
        UIView.animate(withDuration: 0.2)
        {
            self.superTabViewController.view.layoutIfNeeded()
        }
    }
}
