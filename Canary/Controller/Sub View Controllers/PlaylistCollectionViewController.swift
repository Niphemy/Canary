//
//  PlaylistCollectionViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 26/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "SongCell"

class PlaylistCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    let context : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let playlist : Playlist
    var songs = [Song]()
    
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
        
        loadSongs()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return songs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SavedSongCollectionViewCell
        let song = songs[indexPath.item]
        let songImage : UIImage = UIImage(contentsOfFile: song.getImageFilePath().path) ?? UIImage(named: "DefaultSongIcon")!.withTintColor(view.tintColor)
        
        cell.setDisplayData(image: songImage, name: song.name, artists: song.artists, duration: song.duration)
        
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
    
    // MARK: - Library Data Model CRUD Methods
    
    func loadSongs()
    {
        if playlist.getName() == "All Downloads"
        {
            let songFetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
            
            do
            {
                songs = try context.fetch(songFetchRequest)
            }
            catch
            {
                print("Error loading context:\n\(error)")
            }
        }else{
            print("other code")
        }
    }
}
