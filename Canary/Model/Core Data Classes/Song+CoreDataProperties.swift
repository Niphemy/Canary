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

    @NSManaged public var artists: String?
    @NSManaged public var audioFilePath: URL?
    @NSManaged public var imageFilePath: URL?
    @NSManaged public var mediaIdentifier: String?
    @NSManaged public var name: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var parentPlaylist: NSSet?

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
