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
    static let calendar = Calendar.current
    
    static var currentDay : weekdays
    {
        get
        {
            let value = calendar.component(.weekday, from: Date())
            var outputDay = weekdays.monday
            
            outputDay = weekdays.allCases.first(where: { $0.rawValue == value })!
            
            return outputDay
        }
    }
    
    static var resetDate : Date
    {
        set
        {
            UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: "resetDate")
        }
        get
        {
            let fetchedResetInterval = UserDefaults.standard.float(forKey: "resetDate")
            
            if fetchedResetInterval != 0
            {
                return Date(timeIntervalSince1970: TimeInterval(fetchedResetInterval))
            }
            else
            {
                let newResetDate = nextMonday
                UserDefaults.standard.set(newResetDate.timeIntervalSince1970, forKey: "resetDate")
                return newResetDate
            }
        }
    }
    
    private static func resetPlaytimes()
    {
        let songFetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
                
        do
        {
            let songs = try Canary.appContext.fetch(songFetchRequest)
            songs.forEach({ $0.resetPlaytime() })
            Canary.saveAppContext()
        }
        catch
        {
            print("Error loading context:\n\(error)")
        }
    }
    
    static public func setupStartupProcesses()
    {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:
        { (timer) in
            if Canary.sharedAudioPlayer.isPlaying
            {
                Canary.sharedAudioPlayer.currentlyPlaying.song?.playtime += 1
                var tempTiming = Canary.weekdayTimings
                
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
                
                Canary.weekdayTimings = tempTiming
                Canary.saveAppContext()
            }
        })
        
        let rightNow = Date()
        
        if rightNow > resetDate
        {
            resetPlaytimes()
            Canary.weekdayTimings = ["mon":0, "tue":0, "wed":0, "thu":0, "fri":0, "sat":0, "sun":0]
            
            self.resetDate = nextMonday
        }
    }
    
    static var nextMonday : Date
    {
        get
        {
            let rightNow = Date()
            var nextMonday = Date()

            let rightNowDayOfMonth = calendar.component(.day, from: rightNow)
            
            while calendar.component(.weekday, from: nextMonday) != 2 || rightNowDayOfMonth == calendar.component(.day, from: nextMonday)
            {
                nextMonday = calendar.date(byAdding: .day, value: 1, to: nextMonday)!
            }

            return calendar.dateInterval(of: .day, for: nextMonday)!.start
        }
    }
    
    static public func getArtistTimingData() -> [String : Float]
    {
        var songs = [Song]()
        var allArtists = [String]()

        let songFetchRequest : NSFetchRequest<Song> = Song.fetchRequest()

        do{ songs = try Canary.appContext.fetch(songFetchRequest) }
        catch{ print("Error loading context:\n\(error)") }

        for song in songs
        {
            var songArtists = song.artists.components(separatedBy: ", ")

            for i in 0..<songArtists.count
            {
                if songArtists[i].contains("ft. ")
                {
                    allArtists.append(contentsOf: songArtists[i].components(separatedBy: " ft. "))
                    songArtists[i] = ""
                }else if songArtists[i].contains(" & ")
                {
                    allArtists.append(contentsOf: songArtists[i].components(separatedBy: " & "))
                    songArtists[i] = ""
                }
            }

            for artist in songArtists
            {
                let lowercaseArtist = artist.lowercased()

                if !allArtists.contains(lowercaseArtist)
                {
                    allArtists.append(artist)
                }
            }
        }

        allArtists.removeAll(where: { $0 == "" })
        
        var artistTimes : [String : Float] = [String : Float]()
        for artist in allArtists
        {
            for song in songs
            {
                if song.artists.contains(artist)
                {
                    if artistTimes[artist] != nil
                    {
                        artistTimes[artist]! += Float(song.playtime)
                    }else
                    {
                        artistTimes[artist] = Float(song.playtime)
                    }
                }
            }
        }
        
        return artistTimes
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
