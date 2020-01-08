//
//  PlaybackStackView.swift
//  Canary
//
//  Created by Nifemi Fatoye on 15/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class PlaybackStackView: UIStackView
{
    private let playPauseButton = UIButton()
    private let previousTrackButton = UIButton()
    private let nextTrackButton = UIButton()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init()
    {
        super.init(frame: CGRect())
        
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleButtonImage), name: .PlaybackChanged, object: nil)
        
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(shrink(_:)), for: .touchDown)
        playPauseButton.addTarget(self, action: #selector(returnToOriginalSize(_:)), for: .touchCancel)
        
        previousTrackButton.addTarget(self, action: #selector(previousTrackButtonTapped), for: .touchUpInside)
        previousTrackButton.addTarget(self, action: #selector(shrink(_:)), for: .touchDown)
        previousTrackButton.addTarget(self, action: #selector(returnToOriginalSize(_:)), for: .touchCancel)
        
        nextTrackButton.addTarget(self, action: #selector(nextTrackButtonTapped), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(shrink(_:)), for: .touchDown)
        nextTrackButton.addTarget(self, action: #selector(returnToOriginalSize(_:)), for: .touchCancel)
        
        addArrangedSubview(previousTrackButton)
        addArrangedSubview(playPauseButton)
        addArrangedSubview(nextTrackButton)
        
        playPauseButton.showsTouchWhenHighlighted = true
        playPauseButton.setImage(UIImage.pauseIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 70)), for: .normal)
        
        previousTrackButton.showsTouchWhenHighlighted = true
        previousTrackButton.setImage(UIImage.previousTrackIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        
        nextTrackButton.showsTouchWhenHighlighted = true
        nextTrackButton.setImage(UIImage.nextTrackIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
    }
    
    @objc private func playPauseButtonTapped()
    {
        UIApplication.sharedAudioPlayer.togglePlayPause()
        toggleButtonImage()
        returnToOriginalSize(playPauseButton)
    }
    
    @objc private func toggleButtonImage()
    {
        if UIApplication.sharedAudioPlayer.isPlaying
        {
            playPauseButton.setImage(UIImage.pauseIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 70)), for: .normal)
        }
        else
        {
            playPauseButton.setImage(UIImage.playIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 70)), for: .normal)
        }
    }
    
    @objc private func previousTrackButtonTapped()
    {
        UIApplication.sharedAudioPlayer.previousTrack()
        returnToOriginalSize(previousTrackButton)
    }
    
    @objc private func nextTrackButtonTapped()
    {
        UIApplication.sharedAudioPlayer.nextTrack()
        returnToOriginalSize(nextTrackButton)
    }
    
    @objc private func shrink(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.2)
        {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @objc private func returnToOriginalSize(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.2)
        {
            sender.transform = .identity
        }
    }
}
