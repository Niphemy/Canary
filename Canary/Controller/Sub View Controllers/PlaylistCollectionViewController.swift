//
//  PlaylistCollectionViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 26/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SongCell"

class PlaylistCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    private let playlist : Playlist
    var lastSelectedIndex : IndexPath?
    
    init(playlist: Playlist)
    {
        self.playlist = playlist
        super.init(collectionViewLayout: .verticalFlow)
        navigationItem.title = playlist.getName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView!.register(SavedSongCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.allowsMultipleSelection = false
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SavedSongCollectionViewCell
        cell.setDisplayData(image: UIImage(named: "DefaultSongIcon")!, name: "Middle", artists: "DJ Snake ft. Bipolar Sunshine", duration: "3:40")
        
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.songCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
