//
//  Extensions.swift
//  Canary
//
//  Created by Nifemi Fatoye on 25/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

extension UIApplication
{
    static let sharedAudioPlayer : CanaryAudioPlayer = CanaryAudioPlayer()
}

extension UIFont
{
    static let montserratLight = UIFont(name: "Montserrat-Light", size: 15)!
    static let montserratMedium = UIFont(name: "Montserrat-Medium", size: 15)!
    static let montserratBold = UIFont(name: "Montserrat-Bold", size: 15)!
    static let montserratSemiBold = UIFont(name: "Montserrat-SemiBold", size: 15)!
    static let montserratRegular = UIFont(name: "Montserrat-Regular", size: 15)!
}

extension UIColor
{
    static let dynamicTextColor = UIColor(named: "AdaptableTextColour")!
    static let dynamicCellColor = UIColor(named: "AdaptableCellColour")!
    static var globalTintColor = UIColor.systemBlue
}

extension UIImage
{
    static let defaultSongIcon = UIImage(named: "DefaultSongIcon")!.withTintColor(UIColor.globalTintColor)
    static let homeIcon = UIImage(systemName: "music.house.fill")
    static let searchIcon = UIImage(systemName: "magnifyingglass")
    static let libraryIcon = UIImage(systemName: "rectangle.stack.fill")
    static let userIcon = UIImage(systemName: "person.crop.circle")
    static let downloadIcon = UIImage(systemName: "square.and.arrow.down.fill")
    static let addPlaylistIcon = UIImage(systemName: "rectangle.stack.fill.badge.plus")
    static let ellipsisIcon = UIImage(systemName: "ellipsis")
    static let deleteIcon = UIImage(systemName: "minus.square.fill")
    static let previousTrackIcon = UIImage(systemName: "backward.end.fill")
    static let nextTrackIcon = UIImage(systemName: "forward.end.fill")
    static let playIcon = UIImage(systemName: "play.fill")
    static let pauseIcon = UIImage(systemName: "pause.fill")
}

extension UIView
{
    func highlightBorders()
    {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    static let genericTabBar = UITabBarController().tabBar
}

extension String
{
    var fullRange : NSRange
    {
        get
        {
            return NSRange(location: 0, length: self.count)
        }
    }
}

extension UICollectionViewLayout
{
    static let verticalFlow : UICollectionViewFlowLayout =
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
}

extension NSManagedObjectContext
{
    static let canaryAppContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveCanaryAppContext()
    {
        do
        {
            try canaryAppContext.save()
        } catch {
            print("Error saving context:\n\(error)")
        }
    }
}

extension CGSize
{
    static let songCellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 75)
    static let homeCellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height*0.7)
}

extension Notification.Name
{
    static var SongChanged: Notification.Name
    {
        return .init(rawValue: "AudioPlayer.SongChanged")
    }
    
    static var PlaybackChanged: Notification.Name
    {
        return .init(rawValue: "AudioPlayer.PlaybackChanged")
    }
}
