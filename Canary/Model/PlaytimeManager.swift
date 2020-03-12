//
//  PlaytimeManager.swift
//  Canary
//
//  Created by Nifemi Fatoye on 08/02/2020.
//  Copyright © 2020 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

struct PlaytimeManager
{
    static var resetDate : Date
    {
        get
        {
            return Date()
        }
    }
    
    static var currentDay : weekdays
    {
        get
        {
            let value = calendar.component(.weekday, from: Date())
            var returnDay = weekdays.monday
            
            for day in weekdays.allCases
            {
                if value == day.rawValue
                {
                    returnDay = day
                }
            }
            
            return returnDay
        }
    }
    
    static let calendar = Calendar.current
    private func resetPlaytimes()
    {
        let songFetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
                
        do
        {
            let songs = try NSManagedObjectContext.canaryAppContext.fetch(songFetchRequest)
            songs.forEach({ $0.resetPlaytime() })
        }
        catch
        {
            print("Error loading context:\n\(error)")
        }
    }
    
    static public func setupPlaytimeCounter()
    {
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:
        { (timer) in
            if UIApplication.sharedAudioPlayer.isPlaying
            {
                UIApplication.sharedAudioPlayer.currentlyPlaying.song?.playtime += 1
                var tempTiming = UIApplication.weekdayTimings
                
                switch currentDay
                {
                case .sunday:
                    tempTiming["sun"]! += 1
                case .monday:
                    tempTiming["mon"]! += 1
                case .tuesday:
                    tempTiming["tue"]! += 1
                case .wednesday:
                    tempTiming["wed"]! += 1
                case .thursday:
                    tempTiming["thu"]! += 1
                case .friday:
                    tempTiming["fri"]! += 1
                case .saturday:
                    tempTiming["sat"]! += 1
                }
                
                UIApplication.weekdayTimings = tempTiming
                NSManagedObjectContext.saveCanaryAppContext()
            }
        })
    }
}

enum weekdays : Int, CaseIterable
{
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}
