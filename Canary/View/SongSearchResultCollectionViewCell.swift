//
//  SongSearchResultCollectionViewCell.swift
//  Canary
//
//  Created by Nifemi Fatoye on 28/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class SongSearchResultCollectionViewCell: SongCollectionViewCell
{
    private let loadingImageView = LoadingView()
    private let loadingDetailsLabel = LoadingView()
    private let loadingDynamicButton = LoadingView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupLoadingImageView()
        setupLoadingDetailsLabel()
        setupLoadingDynamicButton()
    }
    
    private func setupLoadingImageView()
    {
        imageView.addSubview(loadingImageView)
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        loadingImageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        loadingImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        loadingImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        loadingImageView.backgroundColor = UIColor.systemGray5
    }
    
    private func setupLoadingDetailsLabel()
    {
        detailsLabel.addSubview(loadingDetailsLabel)
        loadingDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingDetailsLabel.heightAnchor.constraint(equalTo: detailsLabel.heightAnchor, multiplier: 0.6).isActive = true
        loadingDetailsLabel.leadingAnchor.constraint(equalTo: detailsLabel.leadingAnchor).isActive = true
        loadingDetailsLabel.trailingAnchor.constraint(equalTo: detailsLabel.trailingAnchor).isActive = true
        loadingDetailsLabel.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor).isActive = true
        
        loadingDetailsLabel.backgroundColor = UIColor.systemGray5
        loadingDetailsLabel.layer.cornerRadius = 8
    }
    
    private func setupLoadingDynamicButton()
    {
        dynamicButton.addSubview(loadingDynamicButton)
        loadingDynamicButton.translatesAutoresizingMaskIntoConstraints = false
        loadingDynamicButton.heightAnchor.constraint(equalTo: dynamicButton.heightAnchor).isActive = true
        loadingDynamicButton.leadingAnchor.constraint(equalTo: dynamicButton.leadingAnchor).isActive = true
        loadingDynamicButton.trailingAnchor.constraint(equalTo: dynamicButton.trailingAnchor).isActive = true
        loadingDynamicButton.centerYAnchor.constraint(equalTo: dynamicButton.centerYAnchor).isActive = true
        
        loadingDynamicButton.backgroundColor = UIColor.systemGray5
        loadingDynamicButton.layer.cornerRadius = 8
    }
    
    override func dynamicButtonTappedAction()
    {
        
    }
    
    public func setDisplayInfo(with searchResult: SongSearchResult)
    {
        if searchResult.hasLoaded
        {
            
        }
    }
}
