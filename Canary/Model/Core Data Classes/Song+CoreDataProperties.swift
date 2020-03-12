//
//  Song+CoreDataProperties.swift
//  Canary
//
//  Created by Nifemi Fatoye on 26/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//
//

import Foundation
import CoreData

extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged var artists: String
    @NSManaged var playtime: Int16
    @NSManaged var mediaIdentifier: String
    @NSManaged var name: String
    @NSManaged var dateAdded: Date
    @NSManaged var duration: String
    @NSManaged var parentPlaylist: NSSet?
    
    // Getters are provided for the audiofile because the path to the documents directory is not the same on startup
    
    private var audioFilePath: URL?
    {
        get
        {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory.appendingPathComponent("\(mediaIdentifier).mp3")
        }
    }
    
    private var imageFilePath: URL?
    {
        get
        {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory.appendingPathComponent("\(mediaIdentifier).png")
        }
    }
    
    public func setDetails(id: String, artists: String, name: String, date: Date, duration: String)
    {
        self.mediaIdentifier = id
        self.artists = artists
        self.name = name
        self.dateAdded = date
        self.duration = duration
        self.playtime = 0
    }
    
    public func incrementPlaytime()
    {
        self.playtime += 1
    }
    
    public func resetPlaytime()
    {
        self.playtime = 0
    }
    
    public func getAudioFilePath() -> URL
    {
        return audioFilePath!
    }
    
    public func getImageFilePath() -> URL
    {
        return imageFilePath!
    }
}

// MARK: Generated accessors for parentPlaylist

extension Song {

    @objc(addParentPlaylistObject:)
    @NSManaged public func addToParentPlaylist(_ value: Playlist)

    @objc(removeParentPlaylistObject:)
    @NSManaged public func removeFromParentPlaylist(_ value: Playlist)

    @objc(addParentPlaylist:)
    @NSManaged public func addToParentPlaylist(_ values: NSSet)

    @objc(removeParentPlaylist:)
    @NSManaged public func removeFromParentPlaylist(_ values: NSSet)

}
