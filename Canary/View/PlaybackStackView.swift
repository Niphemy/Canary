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
    private let playPauseButton : PlaybackButton = PlaybackButton(type: .playPause, pointSizeForImage: 70)
    private let previousTrackButton : PlaybackButton = PlaybackButton(type: .backSkip, pointSizeForImage: 40)
    private let nextTrackButton : PlaybackButton = PlaybackButton(type: .forwardSkip, pointSizeForImage: 40)
    
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
        
        addArrangedSubview(previousTrackButton)
        addArrangedSubview(playPauseButton)
        addArrangedSubview(nextTrackButton)
    }
}
