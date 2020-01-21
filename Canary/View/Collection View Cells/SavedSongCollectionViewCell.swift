//
//  SavedSongCollectionViewCell.swift
//  Canary
//
//  Created by Nifemi Fatoye on 01/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

protocol SavedSongCollectionViewDelegate : class
{
    func songDetailsTapped(song: Song)
    func songCellTapped(song: Song)
}

class SavedSongCollectionViewCell: SongCollectionViewCell
{
    private var details : (name : String, artists: String) = ("","")
    public weak var delegate : SavedSongCollectionViewDelegate?
    public var song : Song?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        let tintedImage = UIImage.ellipsisIcon?.withTintColor(UIColor.globalTintColor).withConfiguration(UIImage.SymbolConfiguration(pointSize: 50))
        dynamicButton.imageView?.contentMode = .scaleAspectFit
        dynamicButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        dynamicButton.setImage(tintedImage, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAction))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedAction()
    {
        highlightCell()
        guard let song = self.song else { fatalError("You must set the song before returning SavedSongCollectionViewCells") }
        delegate?.songCellTapped(song: song)
    }
    
    override func setDisplayData(image: UIImage, name: String, artists: String, duration: String)
    {
        super.setDisplayData(image: image, name: name, artists: artists, duration: duration)
        details.name = name
        details.artists = artists
    }
    
    func unHighlightCell()
    {
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        let attributedName : NSAttributedString = NSAttributedString(string: details.name, attributes: nameAttributes)
        let attributedArtists : NSAttributedString = NSAttributedString(string: "\n\(details.artists)", attributes: artistAttributes)
        
        let details : NSMutableAttributedString =
        {
            let tempDetails = NSMutableAttributedString()
            tempDetails.append(attributedName)
            tempDetails.append(attributedArtists)
            return tempDetails
        }()
        
        detailsLabel.attributedText = details
    }
    
    func highlightCell()
    {
        contentView.layer.borderColor = UIColor.globalTintColor.cgColor
        
        let highlightedNameAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : tintColor!, NSAttributedString.Key.font : UIFont.montserratMedium.withSize(16)]
        let highlightedArtistsAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor, NSAttributedString.Key.font : UIFont.montserratLight.withSize(16)]
        
        let highlightedName : NSAttributedString = NSAttributedString(string: details.name, attributes: highlightedNameAttributes)
        let highlightedArtists : NSAttributedString = NSAttributedString(string: "\n\(details.artists)", attributes: highlightedArtistsAttributes)
        
        let details : NSMutableAttributedString =
        {
            let tempDetails = NSMutableAttributedString()
            tempDetails.append(highlightedName)
            tempDetails.append(highlightedArtists)
            return tempDetails
        }()
        
        detailsLabel.attributedText = details
    }
    
    override func dynamicButtonTappedAction()
    {
        guard let song = self.song else { fatalError("You must set a song before returning SavedSongCollectionViewCells") }
        delegate?.songDetailsTapped(song: song)
    }
}
