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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewCell
        cell.setDisplayData(image: UIImage(named: "DefaultSongIcon")!, name: "A Downloaded Song", artists: "An Artist", duration: "5:00")
        
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width - 30, height: 80)
    }
}
