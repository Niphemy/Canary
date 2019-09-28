//
//  SongSearchResult.swift
//  Canary
//
//  Created by Nifemi Fatoye on 27/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

struct SongSearchResult
{
    private var artists: String? = nil
    private var duration: String? = nil
    private var image: UIImage? = nil
    private var name: String? = nil
    private var mediaID: String
    private var hasLoaded: Bool
    {
        get
        {
            return (artists != nil && duration != nil && image != nil && name != nil)
        }
    }
    
    init(mediaID: String)
    {
        self.mediaID = mediaID
    }
    
    public mutating func setDetailsFrom(youtubeTitle: String)
    {
        var rawTitle = youtubeTitle
        replaceEncodedCharacters(in: &rawTitle)
        name = parseSongName(from: rawTitle)
        artists = parseArtists(from: rawTitle)
    }
    
    public mutating func setDuration(to length: String)
    {
        duration = length
    }
    
    private func replaceEncodedCharacters(in codedString: inout String)
    {
        let ampersandPattern = "[&amp;]"
        let quotePattern = "[&quot;]"
        let apostrophePattern = "[&#39;]"
        
        codedString = (codedString as NSString).replacingOccurrences(of: ampersandPattern, with: "&", options: .regularExpression, range: codedString.fullRange)
        codedString = (codedString as NSString).replacingOccurrences(of: quotePattern, with: "\"", options: .regularExpression, range: codedString.fullRange)
        codedString = (codedString as NSString).replacingOccurrences(of: apostrophePattern, with: "\'", options: .regularExpression, range: codedString.fullRange)
    }
    
    private func parseSongName(from inputTitle: String) -> String
    {
        let bracketPattern = " \\(.+\\)| \\[.+\\]"
        let featuringPattern = " ft\\..+ | feat\\..+| feat.+| ft.+"
        let separatorPattern = ".+- |.+– |.+\\w+: "
        
        var songName = inputTitle
        
        songName = (songName as NSString).replacingOccurrences(of: separatorPattern, with: "", options: .regularExpression, range: songName.fullRange)
        songName = (songName as NSString).replacingOccurrences(of: bracketPattern, with: "", options: .regularExpression, range: songName.fullRange)
        songName = (songName as NSString).replacingOccurrences(of: featuringPattern, with: "", options: .regularExpression, range: songName.fullRange)
        
        return songName
    }
    
    private func parseArtists(from inputTitle: String) -> String
    {
        var artists = [String]()
        var songName = inputTitle
        
        let separatorRegex = try! NSRegularExpression(pattern: "^(.+?(- |– ))")
        let bracketRegex = try! NSRegularExpression(pattern: "\\(.*(feat\\.|ft|feat|ft\\.)[^\\(\\)]*\\)", options: .caseInsensitive)
        let squareBracketRegex = try! NSRegularExpression(pattern: "\\[.*(feat\\.|ft|feat|ft\\.)[^\\(\\)]*\\]", options: .caseInsensitive)
        let featuringRegex = try! NSRegularExpression(pattern: " ft\\..+| feat\\..+| feat.+| ft.+", options: .caseInsensitive)
        
        let separatorMatchRange = separatorRegex.matches(in: songName, range: songName.fullRange)
        if !(separatorMatchRange.isEmpty)
        {
            var firstMatch : String = (songName as NSString).substring(with: separatorMatchRange[0].range)
            firstMatch = String(firstMatch.prefix(firstMatch.count - 2))
            firstMatch = (firstMatch as NSString).replacingOccurrences(of: " +$", with: "", options: .regularExpression, range: firstMatch.fullRange)
            artists.append(firstMatch)
            songName = (songName as NSString).replacingOccurrences(of: firstMatch, with: "", range: songName.fullRange)
        }
        
        let bracketMatchRange = bracketRegex.matches(in: songName, range: songName.fullRange)
        if !(bracketMatchRange.isEmpty)
        {
            var firstMatch : String = (songName as NSString).substring(with: bracketMatchRange[0].range)
            firstMatch = (firstMatch as NSString).replacingOccurrences(of: "\\(|\\)", with: "", options: .regularExpression, range: firstMatch.fullRange)
            artists.append(firstMatch)
        }
        
        let squareBracketMatchRange = squareBracketRegex.matches(in: songName, range: songName.fullRange)
        if !(squareBracketMatchRange.isEmpty)
        {
            var firstMatch : String = (songName as NSString).substring(with: squareBracketMatchRange[0].range)
            firstMatch = (firstMatch as NSString).replacingOccurrences(of: "\\[|\\]", with: "", options: .regularExpression, range: firstMatch.fullRange)
            artists.append(firstMatch)
        }
        
        let bracketPattern = " \\(.+\\)| \\[.+\\]"
        songName = (songName as NSString).replacingOccurrences(of: bracketPattern, with: "", options: .regularExpression, range: songName.fullRange)
        
        let featuringMatchRange = featuringRegex.matches(in: songName, range: songName.fullRange)
        if !(featuringMatchRange.isEmpty)
        {
            var firstMatch : String = (songName as NSString).substring(with: featuringMatchRange[0].range)
            firstMatch = (firstMatch as NSString).replacingOccurrences(of: "^ +", with: "", options: .regularExpression, range: firstMatch.fullRange)
            artists.append(firstMatch)
        }
        
        return artists.joined(separator: ", ")
    }
}
