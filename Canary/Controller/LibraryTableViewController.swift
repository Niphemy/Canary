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

class LibraryTableViewController: UITableViewController, UITextFieldDelegate
{
    var userPlaylists = [Playlist](), generatedPlaylists = [Playlist]()
    private var addPlaylistAction : UIAlertAction?
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.addPlaylistIcon, style: .plain, target: self, action: #selector(addPlaylist))
        let backButton = UIBarButtonItem(title: navigationItem.title, style: .plain, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratMedium.withSize(17)], for: .normal)
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func addPlaylist(_ sender: Any)
    {
        let playlistNames : [String] =
        {
            var tempPlaylistNames : [String] = [String]()
            allPlaylists.forEach({$0.forEach({ tempPlaylistNames.append($0.getName()) })})
            return tempPlaylistNames
        }()
        
        var playlistCount = self.userPlaylists.count + 1
        var optionalPlaylistName = "My Playlist #\(playlistCount)"
        var nameClash = true
        
        while nameClash
        {
            for playlistName in playlistNames
            {
                if optionalPlaylistName == playlistName
                {
                    playlistCount += 1
                    nameClash = true
                    break
                }
                else
                {
                    nameClash = false
                }
                
                optionalPlaylistName = "My Playlist #\(playlistCount)"
            }
        }
        
        optionalPlaylistName = "My Playlist #\(playlistCount)"
        
        let addPlaylistAlertController : UIAlertController = UIAlertController(title: "Name your new playlist", message: nil, preferredStyle: .alert)
        
        var addPlaylistTextFieldCopy = UITextField()
        
        addPlaylistAlertController.addTextField
        { (addPlaylistTextField) in
            addPlaylistTextField.placeholder = optionalPlaylistName
            addPlaylistTextField.font = UIFont.montserratMedium
            addPlaylistTextField.autocapitalizationType = .words
            addPlaylistTextField.adjustsFontSizeToFitWidth = true
            addPlaylistTextField.delegate = self
            addPlaylistTextFieldCopy = addPlaylistTextField
        }
        
        addPlaylistAction = UIAlertAction(title: "Create", style: .default)
        { (_) in
            let newPlaylist = Playlist(context: NSManagedObjectContext.canaryAppContext)
            
            if addPlaylistTextFieldCopy.text?.count == 0
            {
                newPlaylist.setName(to: optionalPlaylistName)
            }
            else
            {
                newPlaylist.setName(to: addPlaylistTextFieldCopy.text ?? optionalPlaylistName)
            }
            
            self.userPlaylists.append(newPlaylist)
            self.tableView.insertRows(at: [IndexPath(row: self.userPlaylists.count-1, section: 0)], with: .automatic)
            NSManagedObjectContext.saveCanaryAppContext()
        }
        
        addPlaylistAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addPlaylistAlertController.addAction(addPlaylistAction!)
        
        present(addPlaylistAlertController,animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        var playlistNames : [String] = [String]()
        allPlaylists.forEach({$0.forEach({ playlistNames.append($0.getName()) })})
    
        for playlistName in playlistNames
        {
            if playlistName == updatedString
            {
                addPlaylistAction?.isEnabled = false
                break
            }else{
                addPlaylistAction?.isEnabled = true
            }
        }
        
        return true
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return allPlaylists.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allPlaylists[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let cellTextColour = (indexPath == [0,0]) ? UIColor.white : UIColor.dynamicTextColor
        let cellTextAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.montserratMedium.withSize(17), NSAttributedString.Key.foregroundColor: cellTextColour]
        
        cell.backgroundColor = (indexPath == [0,0]) ? view.tintColor : UIColor.systemBackground
        cell.textLabel?.attributedText = NSAttributedString(string: "\(allPlaylists[indexPath.section][indexPath.row].getName())", attributes: cellTextAttributes)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return !(indexPath == [0,0] || indexPath.section == 1)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let playlistToDelete = userPlaylists[indexPath.row]
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
            
            let deletePlaylistAlertController : UIAlertController = UIAlertController(title: "Delete \"\(playlistToDelete.getName())\"?", message: "Are you sure want to delete this playlist containing \(deleteText)", preferredStyle: .alert)
            
            let deletePlaylistAction : UIAlertAction = UIAlertAction(title: "Delete", style: .destructive)
            { (_) in
                self.userPlaylists.remove(at: indexPath.row)
                NSManagedObjectContext.canaryAppContext.delete(playlistToDelete)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                NSManagedObjectContext.saveCanaryAppContext()
                tableView.reloadData()
            }
            
            deletePlaylistAlertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            deletePlaylistAlertController.addAction(deletePlaylistAction)
            present(deletePlaylistAlertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        50
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedPlaylist : Playlist = allPlaylists[indexPath.section][indexPath.row]
        let playlistViewController : PlaylistCollectionViewController = PlaylistCollectionViewController(playlist: selectedPlaylist)
        navigationController?.pushViewController(playlistViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Library Data Model CRUD Methods
    
    func loadPlaylists()
    {
        let playlistFetchRequest : NSFetchRequest<Playlist> = Playlist.fetchRequest()
        do
        {
            userPlaylists = try NSManagedObjectContext.canaryAppContext.fetch(playlistFetchRequest)
        } catch {
            print("Error loading context:\n\(error)")
        }
        
        if userPlaylists.isEmpty
        {
            let allDownloadsPlaylist = Playlist(context: NSManagedObjectContext.canaryAppContext)
            allDownloadsPlaylist.setName(to: "All Downloads")
            userPlaylists.append(allDownloadsPlaylist)
            NSManagedObjectContext.saveCanaryAppContext()
        }
    }
}
