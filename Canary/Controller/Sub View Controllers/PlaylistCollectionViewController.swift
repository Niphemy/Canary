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
    public let playlist : Playlist
    private var songs = [Song]()
    
    init(playlist: Playlist)
    {
        self.playlist = playlist
        super.init(collectionViewLayout: .songFlowLayout)
        navigationItem.title = playlist.getName()
        NotificationCenter.default.addObserver(self, selector: #selector(songDidChange), name: .SongChanged, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.shuffleIcon, style: .plain, target: self, action: #selector(shufflePlaylist))
    }
    
    required init?(coder: NSCoder)
    {
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
    
    @objc func shufflePlaylist()
    {
        songs = songs.shuffled()
        songCellTapped(song: songs[0])
    }
    
    @objc func songDidChange()
    {
        collectionView.reloadData()
    }
    
    func presentDeleteAlert(for song: Song)
    {
        var message = ""
        var actionCode : () -> Void = {}
        
        if playlist.getName() == "All Downloads"
        {
            message = "Deleting songs from all downloads will delete it from your device"
            
            actionCode =
            {
                do
                {
                    try FileManager.default.removeItem(at: song.getAudioFilePath())
                    try FileManager.default.removeItem(at: song.getImageFilePath())
                    NSManagedObjectContext.canaryAppContext.delete(song)
                    NSManagedObjectContext.saveCanaryAppContext()
                }
                    
                catch{print(error.localizedDescription)}
            }
            
        }
        else
        {
            message = "This song will be removed from \(playlist.getName())"
            
            actionCode =
            {
                do
                {
                    song.removeFromParentPlaylist(self.playlist)
                    NSManagedObjectContext.saveCanaryAppContext()
                }
            }
        }
        
        let deleteAlertController = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        { (_) in
            actionCode()
            self.songs.removeAll(where: {$0 == song})
            self.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        deleteAlertController.addAction(deleteAction)
        deleteAlertController.addAction(cancelAction)
        
        present(deleteAlertController, animated: true, completion: nil)
    }
    
    func presentAddablePlaylist(for song: Song)
    {
        let addPlaylistViewController = AddPlaylistTableViewController(song: song)
        let playlistNavigationController = UINavigationController(rootViewController: addPlaylistViewController)

        present(playlistNavigationController, animated: true)
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
        let songImage : UIImage = UIImage(contentsOfFile: song.getImageFilePath().path) ?? UIImage.defaultSongIcon
        
        cell.setDisplayData(image: songImage, name: song.name, artists: song.artists, duration: song.duration)
        cell.song = song
        cell.delegate = self
        
        if UIApplication.sharedAudioPlayer.currentlyPlaying == (song, playlist)
        {
            cell.highlightCell()
        }
        else
        {
            cell.unHighlightCell()
        }
        
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
                songs = try NSManagedObjectContext.canaryAppContext.fetch(songFetchRequest)
            }
            catch
            {
                print("Error loading context:\n\(error)")
            }
        }else{
            songs = playlist.getChildSongs().allObjects as! [Song]
        }
    }
}

extension PlaylistCollectionViewController: SavedSongCollectionViewDelegate
{
    func songDetailsTapped(song: Song)
    {
        let actionSheet = UIAlertController(title: "\(song.name)\n\(song.artists)", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .globalTintColor
        
        let addToPlaylistAction = UIAlertAction(title: "Add to playlist", style: .default)
        { (_) in
            self.presentAddablePlaylist(for: song)
        }
        
        let removeSongAction = UIAlertAction(title: "Remove song", style: .destructive)
        { (_) in
            self.presentDeleteAlert(for: song)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addToPlaylistAction.setValue(UIImage.addPlaylistIcon?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), forKey: "image")
        removeSongAction.setValue(UIImage.deleteIcon?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), forKey: "image")
        
        actionSheet.addAction(addToPlaylistAction)
        actionSheet.addAction(removeSongAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func songCellTapped(song: Song)
    {
        UIApplication.sharedAudioPlayer.play(song, from: playlist, songs: songs)
        collectionView.reloadData()
    }
}


