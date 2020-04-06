//
//  PlaybackButton.swift
//  Canary
//
//  Created by Nifemi Fatoye on 09/01/2020.
//  Copyright © 2020 Nifemi Fatoye. All rights reserved.
//

import UIKit

class PlaybackButton: UIButton
{
    private let type : PlaybackButtonType
    private let imagePointSize : CGFloat
    
    init(type: PlaybackButtonType, pointSizeForImage inputSize: CGFloat)
    {
        self.type = type
        imagePointSize = inputSize
        
        super.init(frame: CGRect())
        
        switch type
        {
        case .playPause:
            setImage(UIImage.pauseIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: inputSize)), for: .normal)
            addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
            NotificationCenter.default.addObserver(self, selector: #selector(toggleButtonImage), name: .PlaybackChanged, object: nil)
        case .backSkip:
            setImage(UIImage.previousTrackIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: inputSize)), for: .normal)
            addTarget(self, action: #selector(previousTrackButtonTapped), for: .touchUpInside)
        case .forwardSkip:
            setImage(UIImage.nextTrackIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: inputSize)), for: .normal)
            addTarget(self, action: #selector(nextTrackButtonTapped), for: .touchUpInside)
        }
        
        showsTouchWhenHighlighted = true
        addTarget(self, action: #selector(shrink), for: .touchDown)
        addTarget(self, action: #selector(returnToOriginalSize), for: .touchCancel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func playPauseButtonTapped()
    {
        Canary.sharedAudioPlayer.togglePlayPause()
        toggleButtonImage()
        returnToOriginalSize()
    }
    
    @objc private func toggleButtonImage()
    {
        if Canary.sharedAudioPlayer.isPlaying
        {
            setImage(UIImage.pauseIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: imagePointSize)), for: .normal)
        }
        else
        {
            setImage(UIImage.playIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: imagePointSize)), for: .normal)
        }
    }
    
    @objc private func previousTrackButtonTapped()
    {
        Canary.sharedAudioPlayer.previousTrack()
        returnToOriginalSize()
    }
    
    @objc private func nextTrackButtonTapped()
    {
        Canary.sharedAudioPlayer.nextTrack()
        returnToOriginalSize()
    }
    
    @objc private func shrink()
    {
        UIView.animate(withDuration: 0.2)
        {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @objc private func returnToOriginalSize()
    {
        UIView.animate(withDuration: 0.2)
        {
            self.transform = .identity
        }
    }
}

enum PlaybackButtonType
{
    case playPause
    case backSkip
    case forwardSkip
}
