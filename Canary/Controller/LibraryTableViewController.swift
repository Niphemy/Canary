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
    var userPlaylists = [Playlist](), generatedPlaylists = [Playlist]()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddPlaylistIcon"), style: .plain, target: self, action: nil)
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
        let cellTextColour = (indexPath == [0,0]) ? UIColor.white : UIColor.dynamicText
        let cellTextAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.montserratMedium.withSize(17), NSAttributedString.Key.foregroundColor: cellTextColour]
        
        cell.backgroundColor = (indexPath == [0,0]) ? view.tintColor : UIColor.systemBackground
        cell.textLabel?.attributedText = NSAttributedString(string: "\(allPlaylists[indexPath.section][indexPath.row].getName())", attributes: cellTextAttributes)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(indexPath == [0,0] || indexPath.section == 1)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let playlistToDelete = allPlaylists[indexPath.section][indexPath.row]
            var deleteText = String()
            
            switch playlistToDelete.getNumberOfSongs()
            {
            case 0:
                deleteText = "no songs?"
            case 1:
                deleteText = "one song?"
            default:
                deleteText = "\(playlistToDelete.getNumberOfSongs()) songs?"
            }
            
            let deletePlaylistAlertController : UIAlertController = UIAlertController(title: "Delete \"\(playlistToDelete.getName())\"?", message: "Do you want to delete \(playlistToDelete.getName()) containing \(deleteText)", preferredStyle: .alert)
            
            let deletePlaylistAction : UIAlertAction = UIAlertAction(title: "Delete", style: .destructive)
            { (_) in
                self.userPlaylists.remove(at: indexPath.row)
                self.context.delete(playlistToDelete)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.savePlaylists()
            }
            
            deletePlaylistAlertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            deletePlaylistAlertController.addAction(deletePlaylistAction)
            
            present(deletePlaylistAlertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
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
        tableView.reloadData()
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
