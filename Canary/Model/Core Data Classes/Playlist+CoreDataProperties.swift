//
//  Playlist+CoreDataProperties.swift
//  Canary
//
//  Created by Nifemi Fatoye on 26/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//
//

import Foundation
import CoreData

extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged private var name: String
    @NSManaged private var childSongs: NSSet
    private var numberOfSongs: Int
    {
        get
        {
            return self.childSongs.count ?? 0
        }
    }
    
    public func setName(to name: String)
    {
        self.name = name
    }
    
    public func getName() -> String
    {
        return name
    }
    
    public func getNumberOfSongs() -> Int
    {
        return numberOfSongs
    }
    
    public func getChildSongs() -> NSSet
    {
        return childSongs
    }

}

// MARK: Generated accessors for childSongs
extension Playlist {

    @objc(addChildSongsObject:)
    @NSManaged public func addToChildSongs(_ value: Song)

    @objc(removeChildSongsObject:)
    @NSManaged public func removeFromChildSongs(_ value: Song)

    @objc(addChildSongs:)
    @NSManaged public func addToChildSongs(_ values: NSSet)

    @objc(removeChildSongs:)
    @NSManaged public func removeFromChildSongs(_ values: NSSet)

}
