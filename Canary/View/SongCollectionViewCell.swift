//
//  SongCollectionViewCell.swift
//  Canary
//
//  Created by Nifemi Fatoye on 27/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell
{
    internal let imageView : UIImageView = UIImageView()
    internal let detailsLabel : UILabel = UILabel()
    internal let durationLabel : UILabel = UILabel()
    internal let dynamicButton : UIButton = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 1, height: 2)
        contentView.layer.cornerRadius = 17
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.dynamicCellColor
    }
    
    public func setDisplayData(image: UIImage, name: String, artists: String, duration: String)
    {
        setupImageView(with: image)
        setupDetailsLabel(with: name, and: artists)
        setupDynamicButton()
        setupDurationLabel(with: duration)
    }
    
    private func setupImageView(with image: UIImage)
    {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
    }
    
    private func setupDetailsLabel(with name: String, and artists: String)
    {
        contentView.addSubview(detailsLabel)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        detailsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        detailsLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55).isActive = true
        
        let nameAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor, NSAttributedString.Key.font : UIFont.montserratMedium.withSize(16)]
        let artistAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font : UIFont.montserratLight.withSize(16)]
        let attributedName : NSAttributedString = NSAttributedString(string: name, attributes: nameAttributes)
        let attributedArtists : NSAttributedString = NSAttributedString(string: "\n\(artists)", attributes: artistAttributes)
        
        let details : NSMutableAttributedString =
        {
            let tempDetails = NSMutableAttributedString()
            tempDetails.append(attributedName)
            tempDetails.append(attributedArtists)
            return tempDetails
        }()
        
        detailsLabel.attributedText = details
        detailsLabel.textAlignment = .left
        detailsLabel.numberOfLines = 2
    }
    
    private func setupDynamicButton()
    {
        contentView.addSubview(dynamicButton)
        dynamicButton.translatesAutoresizingMaskIntoConstraints = false
        dynamicButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dynamicButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        dynamicButton.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        dynamicButton.widthAnchor.constraint(equalTo: detailsLabel.heightAnchor).isActive = true
        
        dynamicButton.showsTouchWhenHighlighted = true
    }
    
    private func setupDurationLabel(with duration: String)
    {
        let containerView = UIView()
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: detailsLabel.trailingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: dynamicButton.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        containerView.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        durationLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        let attributedDuration = NSAttributedString(string: duration, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font : UIFont.montserratMedium.withSize(16)])
        
        durationLabel.attributedText = attributedDuration
    }
    
    
}
