//
//  SongViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 23/11/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

enum ViewMode
{
    case contracted
    case expanded
}

class SongViewController: UIViewController
{
    private let superTabViewController : TabViewController
    private var heightAnchor : NSLayoutConstraint?
    private var bottomAnchor : NSLayoutConstraint?
    private let swipeBuffer : CGFloat = 50
    private let musicViewContainer : MusicView = MusicView()
    private let musicMiniMenu : MiniMenuMusicView = MiniMenuMusicView()
    
    private var isActive : Bool = false
    {
        didSet
        {
            if isActive == true
            {
                self.heightAnchor?.constant = 0
                UIView.animate(withDuration: 0.2)
                {
                    self.superTabViewController.view.layoutIfNeeded()
                }
            }
            else
            {
                self.heightAnchor?.constant = -UIView.genericTabBar.frame.height
            }
        }
    }
    
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
    
    private var maxSafeViewHeight : CGFloat
    {
        let statusBarHeight = view.window!.windowScene!.statusBarManager!.statusBarFrame.height
        let tabBarHeight = superTabViewController.tabBar.frame.height
        return (superTabViewController.view.frame.height - (tabBarHeight + statusBarHeight))
    }
        
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(superTabViewController : TabViewController)
    {
        self.superTabViewController = superTabViewController
        super.init(nibName: nil, bundle: nil)
        UIApplication.sharedAudioPlayer.delegate = self
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
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(blurredEffectView)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurredEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurredEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurredEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurredEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        view.addSubview(musicMiniMenu)
        musicMiniMenu.translatesAutoresizingMaskIntoConstraints = false
        musicMiniMenu.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        musicMiniMenu.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        musicMiniMenu.heightAnchor.constraint(equalToConstant: superTabViewController.tabBar.frame.height).isActive = true
        musicMiniMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(musicViewContainer)
        musicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        musicViewContainer.topAnchor.constraint(equalTo: musicMiniMenu.bottomAnchor).isActive = true
        musicViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        musicViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicViewContainer.heightAnchor.constraint(equalToConstant: maxSafeViewHeight).isActive = true
    }
    
    // MARK: - Animation
    
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
            
            if newHeight < superTabViewController.tabBar.frame.height
            {
                musicMiniMenu.alpha = 1 - (newHeight / superTabViewController.tabBar.frame.height)
                musicViewContainer.alpha = 0
            }
            else if newHeight >= superTabViewController.tabBar.frame.height && newHeight <= 2*superTabViewController.tabBar.frame.height
            {
                musicViewContainer.alpha = (newHeight / superTabViewController.tabBar.frame.height) - 1
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
    
    func fullyExpandView()
    {
        heightAnchor?.constant = maxSafeViewHeight
        viewMode = .expanded
        UIView.animate(withDuration: 0.2)
        {
            self.superTabViewController.view.layoutIfNeeded()
            self.musicViewContainer.alpha = 1
            self.musicMiniMenu.alpha = 0
            self.view.layer.cornerRadius = 15
        }
    }
    
    func fullyContractView()
    {
        heightAnchor?.constant = 0
        viewMode = .contracted
        UIView.animate(withDuration: 0.2)
        {
            self.superTabViewController.view.layoutIfNeeded()
            self.musicMiniMenu.alpha = 1
            self.musicViewContainer.alpha = 0
            self.view.layer.cornerRadius = 0
        }
    }
}

extension SongViewController: CanaryAudioPlayerDelegate
{
    func songWillBeginPlaying(song: Song, from playlist: Playlist)
    {
        musicViewContainer.setDisplayData(from: song, playlist: playlist)
        musicMiniMenu.setDisplayData(song: song)
        
        if isActive == false
        {
            isActive = true
        }
    }
}
