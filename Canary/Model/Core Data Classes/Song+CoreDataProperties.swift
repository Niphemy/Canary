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

    @NSManaged private var name: String?
    @NSManaged private var artists: String?
    @NSManaged private var audioFilePath: URL?
    @NSManaged private var imageFilePath: URL?
    @NSManaged private var mediaIdentifier: String?
    @NSManaged private var parentPlaylist: NSSet?
    
    public func setInfo()
    {
        
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
