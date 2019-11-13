//
//  SavedSongCollectionViewCell.swift
//  Canary
//
//  Created by Nifemi Fatoye on 01/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class SavedSongCollectionViewCell: SongCollectionViewCell
{
    var details : (name : String, artists: String) = ("","")
    
    override var isSelected: Bool
    {
        didSet
        {
            if isSelected && !isHighlighted
            {
                highlightCell()
            }else{
                unHighlightCell()
            }
        }
    }
    
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
    }
    
    public func startPlayingSong()
    {
    
    }
    
    public func stopPlayingSong()
    {
        
    }
    
    private func unHighlightCell()
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
    
    private func highlightCell()
    {
        contentView.layer.borderColor = tintColor.cgColor
        let detailsArray = detailsLabel.attributedText!.string.components(separatedBy: "\n")
        details.name = detailsArray[0]
        details.artists = detailsArray[1]
        
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
}
