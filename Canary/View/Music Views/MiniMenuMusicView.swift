//
//  MiniMenuMusicView.swift
//  Canary
//
//  Created by Nifemi Fatoye on 08/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation
import UIKit

class MiniMenuMusicView: UIView
{
    private let musicTitleLabel : UILabel = UILabel()
    private let musicImageView : UIImageView = UIImageView()
    private let playPauseButton : PlaybackButton = PlaybackButton(type: .playPause, pointSizeForImage: 20)
    private var progressUpdater = CADisplayLink()
    private var playPauseButtonSectorLayer = CAShapeLayer()
    
    init()
    {
        super.init(frame: CGRect())
        
        progressUpdater = CADisplayLink(target: self, selector: #selector(updateProgress))
        progressUpdater.add(to: .main, forMode: .default)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        addSubview(musicImageView)
        musicImageView.translatesAutoresizingMaskIntoConstraints = false
        musicImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.78).isActive = true
        musicImageView.widthAnchor.constraint(equalTo: musicImageView.heightAnchor).isActive = true
        musicImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        musicImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        layoutIfNeeded()
        musicImageView.layer.cornerRadius = musicImageView.frame.width / 5
        musicImageView.layer.masksToBounds = true
        musicImageView.contentMode = .scaleAspectFill
        
        addSubview(musicTitleLabel)
        musicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        musicTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        musicTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        musicTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        musicTitleLabel.textAlignment = .center
        
        addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.heightAnchor.constraint(equalTo: musicImageView.heightAnchor, multiplier: 0.78).isActive = true
        playPauseButton.widthAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playPauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        layoutIfNeeded()
        
        let playPauseButtonCenter : CGPoint = CGPoint(x: playPauseButton.bounds.midX, y: playPauseButton.bounds.midY)
        let radius = playPauseButton.frame.width/2
        let sectorPath = UIBezierPath(arcCenter: playPauseButtonCenter, radius: radius, startAngle: -.pi/2, endAngle: .pi*3/2, clockwise: true)
        
        playPauseButtonSectorLayer.path = sectorPath.cgPath
        playPauseButtonSectorLayer.fillColor = UIColor.clear.cgColor
        playPauseButtonSectorLayer.lineCap = .butt
        playPauseButtonSectorLayer.strokeColor = UIColor.globalTintColor.cgColor
        playPauseButtonSectorLayer.lineWidth = 3
        playPauseButtonSectorLayer.strokeEnd = 0
        
        playPauseButton.layer.addSublayer(playPauseButtonSectorLayer)
    }
    
    public func setDisplayData(song: Song)
    {
        let songImage = UIImage(contentsOfFile: song.getImageFilePath().path) ?? UIImage.defaultSongIcon
        let nameAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.globalTintColor, NSAttributedString.Key.font : UIFont.montserratMedium]
        let artistsAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor, NSAttributedString.Key.font : UIFont.montserratLight]
        
        let attributedName = NSAttributedString(string: song.name, attributes: nameAttributes)
        let attributedArtists = NSAttributedString(string: " \(song.artists)", attributes: artistsAttributes)
        
        let songDetails : NSMutableAttributedString =
        {
            let tempDetails = NSMutableAttributedString()
            tempDetails.append(attributedName)
            tempDetails.append(attributedArtists)
            return tempDetails
        }()
        
        musicImageView.image = songImage
        musicTitleLabel.attributedText = songDetails
    }
    
    @objc private func updateProgress()
    {
        let fractionSongDone = UIApplication.sharedAudioPlayer.currentTime()/UIApplication.sharedAudioPlayer.currentDuration()
        
        playPauseButtonSectorLayer.strokeEnd = CGFloat(fractionSongDone)
    }
}
