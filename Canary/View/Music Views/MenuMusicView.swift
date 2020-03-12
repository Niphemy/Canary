//
//  MenuMusicView.swift
//  Canary
//
//  Created by Nifemi Fatoye on 08/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation
import UIKit

class MenuMusicView : UIView
{
    private let musicImageView : UIImageView = UIImageView()
    private let audioVisualiser : UIView = UIView()
    private let playlistTitleLabel : UILabel = UILabel()
    private let musicInfoButton : UIButton = UIButton()
    private let musicTitleLabel : UILabel = UILabel()
    private let progressTracker : MusicProgressTracker = MusicProgressTracker()
    private let playbackStack : PlaybackStackView = PlaybackStackView()
    private var song : Song? = nil
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        addSubview(playlistTitleLabel)
        playlistTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playlistTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playlistTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        playlistTitleLabel.textAlignment = .center
        
        addSubview(musicInfoButton)
        musicInfoButton.translatesAutoresizingMaskIntoConstraints = false
        musicInfoButton.centerYAnchor.constraint(equalTo: playlistTitleLabel.centerYAnchor).isActive = true
        musicInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        musicInfoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        musicInfoButton.widthAnchor.constraint(equalTo: musicInfoButton.heightAnchor).isActive = true
        musicInfoButton.showsTouchWhenHighlighted = true
        musicInfoButton.setImage(UIImage.ellipsisIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 45)).withTintColor(tintColor), for: .normal)
        
        addSubview(musicImageView)
        musicImageView.translatesAutoresizingMaskIntoConstraints = false
        musicImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        musicImageView.heightAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        musicImageView.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        musicImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        layoutIfNeeded()
        musicImageView.layer.cornerRadius = musicImageView.frame.width / 5
        musicImageView.layer.masksToBounds = true
        musicImageView.contentMode = .scaleAspectFill
        
        addSubview(audioVisualiser)
        audioVisualiser.translatesAutoresizingMaskIntoConstraints = false
        audioVisualiser.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.13).isActive = true
        audioVisualiser.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        audioVisualiser.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 20).isActive = true
        audioVisualiser.centerXAnchor.constraint(equalTo: musicImageView.centerXAnchor).isActive = true
        audioVisualiser.backgroundColor = tintColor
        
        addSubview(progressTracker)
        progressTracker.translatesAutoresizingMaskIntoConstraints = false
        progressTracker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        progressTracker.widthAnchor.constraint(equalTo: audioVisualiser.widthAnchor).isActive = true
        progressTracker.topAnchor.constraint(equalTo: audioVisualiser.bottomAnchor, constant: 5).isActive = true
        progressTracker.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(musicTitleLabel)
        musicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        musicTitleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        musicTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        musicTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIView.genericTabBar.frame.height).isActive = true
        musicTitleLabel.numberOfLines = 2
        musicTitleLabel.textAlignment = .center
        
        addSubview(playbackStack)
        playbackStack.translatesAutoresizingMaskIntoConstraints = false
        playbackStack.widthAnchor.constraint(equalTo: progressTracker.widthAnchor).isActive = true
        playbackStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playbackStack.topAnchor.constraint(equalTo: progressTracker.bottomAnchor).isActive = true
        playbackStack.bottomAnchor.constraint(equalTo: musicTitleLabel.topAnchor).isActive = true
    }
    
    public func setDisplayData(from song: Song, playlist: Playlist)
    {
        let songImage = UIImage(contentsOfFile: song.getImageFilePath().path) ?? UIImage.defaultSongIcon
        let playlistTitleLabelAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor, NSAttributedString.Key.font : UIFont.montserratSemiBold.withSize(16)]
        let nameAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.globalTintColor, NSAttributedString.Key.font : UIFont.montserratSemiBold.withSize(19)]
        let artistsAttribuets : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor, NSAttributedString.Key.font : UIFont.montserratLight.withSize(19)]
        
        let attributedName = NSAttributedString(string: song.name, attributes: nameAttributes)
        let attributedArtists = NSAttributedString(string: "\n\(song.artists)", attributes: artistsAttribuets)
        
        let songDetails : NSMutableAttributedString =
        {
            let tempDetails = NSMutableAttributedString()
            tempDetails.append(attributedName)
            tempDetails.append(attributedArtists)
            return tempDetails
        }()
        
        playlistTitleLabel.attributedText = NSAttributedString(string: playlist.getName(), attributes: playlistTitleLabelAttributes)
        musicImageView.image = songImage
        musicTitleLabel.attributedText = songDetails
        self.song = song
        
        musicInfoButton.addTarget(self, action: #selector(musicInfoButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func musicInfoButtonTapped(_ sender : Any)
    {
        
    }
}
