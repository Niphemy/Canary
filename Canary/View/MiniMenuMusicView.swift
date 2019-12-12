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
    private let pausePlayButton : UIButton = UIButton()
    
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
        
        addSubview(pausePlayButton)
        pausePlayButton.translatesAutoresizingMaskIntoConstraints = false
        pausePlayButton.heightAnchor.constraint(equalTo: musicImageView.heightAnchor, multiplier: 0.78).isActive = true
        pausePlayButton.widthAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
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
}
