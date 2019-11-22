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
    private var details : (name : String, artists: String) = ("","")
    private var superViewController : UIViewController = UIViewController()
    private var song : Song?
    
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
    
    public func setDetails(viewController : UIViewController, song : Song)
    {
        superViewController = viewController
        self.song = song
    }
    
    override func dynamicButtonTappedAction()
    {
        guard let song = song else { fatalError("Cannot use song that does not exist") }
        let actionSheet = UIAlertController(title: detailsLabel.text, message: nil, preferredStyle: .actionSheet)
        let playlistViewController : PlaylistCollectionViewController =  self.superViewController as! PlaylistCollectionViewController
        
        let addToPlaylistAction = UIAlertAction(title: "Add to playlist", style: .default)
        { (_) in
            playlistViewController.presentAddablePlaylist(for: song)
        }
        
        let removeSongAction = UIAlertAction(title: "Remove song", style: .destructive)
        { (_) in
            playlistViewController.presentDeleteAlert(for: song)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addToPlaylistAction.setValue(UIImage.addPlaylistIcon?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), forKey: "image")
        removeSongAction.setValue(UIImage.deleteIcon?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), forKey: "image")
        
        actionSheet.addAction(addToPlaylistAction)
        actionSheet.addAction(removeSongAction)
        actionSheet.addAction(cancelAction)
        
        superViewController.present(actionSheet, animated: true, completion: nil)
    }
}
