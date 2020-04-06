//
//  Extensions.swift
//  Canary
//
//  Created by Nifemi Fatoye on 25/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

struct Canary
{
    static let sharedAudioPlayer : CanaryAudioPlayer = CanaryAudioPlayer()
    static let phpAddress : String = "29613deb"
    
    static var weekdayTimings : [String : Int]
    {
        set
        {
            UserDefaults.standard.set(newValue, forKey: "weekdayTimings")
        }
        get
        {
            if let weekdayTimes = UserDefaults.standard.dictionary(forKey: "weekdayTimings") as? [String : Int]
            {
                return weekdayTimes
            }
            else
            {
                let weekdayTimes : [String : Int] = ["mon":0, "tue":0, "wed":0, "thu":0, "fri":0, "sat":0, "sun":0]
                UserDefaults.standard.set(weekdayTimes, forKey: "weekdayTimings")
                
                return UserDefaults.standard.dictionary(forKey: "weekdayTimings") as? [String : Int] ?? weekdayTimes
            }
        }
    }
    
    static let appContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveAppContext()
    {
        do
        {
            try appContext.save()
        } catch {
            print("Error saving context:\n\(error)")
        }
    }
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
    static let downloadIcon = UIImage(systemName: "square.and.arrow.down.fill")
    static let addPlaylistIcon = UIImage(systemName: "rectangle.stack.fill.badge.plus")
    static let ellipsisIcon = UIImage(systemName: "ellipsis")
    static let deleteIcon = UIImage(systemName: "minus.square.fill")
    static let previousTrackIcon = UIImage(systemName: "backward.end.fill")
    static let nextTrackIcon = UIImage(systemName: "forward.end.fill")
    static let playIcon = UIImage(systemName: "play.fill")
    static let pauseIcon = UIImage(systemName: "pause.fill")
    static let shuffleIcon = UIImage(systemName: "shuffle")
}

extension UIView
{
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
    static let homeFlowLayout : UICollectionViewFlowLayout =
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .homeCellSize
        return flowLayout
    }()
    
    static let songFlowLayout : UICollectionViewFlowLayout =
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .songCellSize
        return flowLayout
    }()
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
