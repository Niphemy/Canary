//
//  AddPlaylistTableViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 22/11/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "PlaylistCell"

class AddPlaylistTableViewController: UITableViewController
{
    private let song : Song
    private var addablePlaylists : [Playlist] = []
    
    init(song : Song)
    {
        self.song = song
        super.init(style: .plain)
        
        navigationController?.modalPresentationStyle = .popover
        title = "Add to playlist"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPlaylistNavigationController))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratMedium], for: .normal)
        
        navigationItem.leftBarButtonItem = cancelButton
        
        setPlaylistsToBeAdded()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.titleTextAttributes = (presentingViewController?.children[2] as! UINavigationController).navigationBar.titleTextAttributes
    }
    
    @objc func dismissPlaylistNavigationController(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return addablePlaylists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let cellTextColour = UIColor.dynamicTextColor
        let cellTextAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.montserratMedium.withSize(17), NSAttributedString.Key.foregroundColor: cellTextColour]
        
        cell.backgroundColor = UIColor.systemBackground
        cell.textLabel?.attributedText = NSAttributedString(string: "\(addablePlaylists[indexPath.row].getName())", attributes: cellTextAttributes)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPlaylist = addablePlaylists[indexPath.row]
        song.addToParentPlaylist(selectedPlaylist)
        NSManagedObjectContext.saveCanaryAppContext()
        
        let addPlaylistCompletionAlert = UIAlertController(title: "\(song.name) was added to \(selectedPlaylist.getName())", message: nil, preferredStyle: .alert)
        
        dismiss(animated: true, completion: nil)
        
        presentingViewController?.present(addPlaylistCompletionAlert, animated: true, completion:
        {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats:false, block:
            {_ in
                addPlaylistCompletionAlert.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        50
    }
    
    func setPlaylistsToBeAdded()
    {
        let parentPlaylists : [Playlist] = song.parentPlaylist?.allObjects as! [Playlist]
        
        let playlistFetchRequest : NSFetchRequest<Playlist> = Playlist.fetchRequest()
        do
        {
            addablePlaylists = try NSManagedObjectContext.canaryAppContext.fetch(playlistFetchRequest)
        } catch {
            print("Error loading context:\n\(error)")
        }
        
        if addablePlaylists[0].getName() == "All Downloads"
        {
            addablePlaylists.remove(at: 0)
        }
        
        for i in 0..<parentPlaylists.count
        {
            let parentPlaylist = parentPlaylists[i]
            let addablePlaylist = addablePlaylists[i]
            
            if parentPlaylist == addablePlaylist
            {
                addablePlaylists.remove(at: i)
            }
        }
    }
}
