//
//  LibraryTableViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 25/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "PlaylistCell"

class LibraryTableViewController: UITableViewController {

    let context : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userPlaylists : [Playlist] = [Playlist]()
    var generatedPlaylists : [Playlist] = [Playlist]()
    var allPlaylists : [[Playlist]]
    {
        get
        {
            return [userPlaylists,generatedPlaylists]
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadPlaylists()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddPlaylistIcon"), style: .plain, target: self, action: nil)
        
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allPlaylists.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allPlaylists[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = (indexPath == [0,0]) ? UIColor.systemBlue : UIColor.systemGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(indexPath == [0,0])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //let cellToDeleteTitle = tableView.cellForRow(at: indexPath)?.textLabel?.text
            //let deletePlaylistAlertController = UIAlertController(title: "Delete \"\(cellToDeleteTitle)\"?", message: "Do you want to delete this playlist containing \(0) songs?", preferredStyle: .alert)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Library Data Model CRUD Methods
    
    func savePlaylists()
    {
        do
        {
            try context.save()
        } catch {
            print("Error saving context:\n\(error)")
        }
    }
    
    func loadPlaylists()
    {
        let playlistFetchRequest : NSFetchRequest<Playlist> = Playlist.fetchRequest()
        do
        {
            userPlaylists = try context.fetch(playlistFetchRequest)
        } catch {
            print("Error loading context:\n\(error)")
        }
        
        if userPlaylists.isEmpty
        {
            let allDownloadsPlaylist = Playlist(context: context)
            allDownloadsPlaylist.setName(to: "All Downloads")
            userPlaylists.append(allDownloadsPlaylist)
            savePlaylists()
        }
    }
}
