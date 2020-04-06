//
//  YTAPI.swift
//  Canary
//
//  Created by Nifemi Fatoye on 15/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

struct YTAPI
{
    private static let baseSearchAPIURL : URL = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    private static let baseVideoAPIURL : URL = URL(string: "https://www.googleapis.com/youtube/v3/videos")!
    private static let baseVideoDownloadURL = URL(string: "https://\(Canary.phpAddress).ngrok.io/phptutorial/convert.php/?youtubelink=https://www.youtube.com/watch?v=")!
    private static let APIKey : String = "AIzaSyD1RJzDF3fhadZzih0Lv0ZKGrLsDTINDFw"
    
    static func getResultsFor(query input: String, _ completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)
    {
        let videoSearchParameters : [String: String] = ["part":"snippet", "q":input, "type":"video", "videoCategoryId":"10", "relevanceLanguage":"en", "maxResults":"15", "key":APIKey]
        let terminalURL : URL = encodeParameters(url: baseSearchAPIURL, parameters: videoSearchParameters)
        
        URLSession.shared.dataTask(with: terminalURL)
        { (data, response, dataError) in
            completionHandler(data, response, dataError)
        }.resume()
    }
    
    static func getDurationFor(searchResults: [SongSearchResult], _ completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)
    {
        var videoIDs : String = searchResults.reduce("", { $0 + "\($1.getMediaID())," })
        
        videoIDs = videoIDs.isEmpty ? videoIDs : String(videoIDs.dropLast(1))
        
        let videoDetailsParemeters : [String: String] = ["part":"contentDetails","id":videoIDs , "key":APIKey]
        let terminalURL : URL = encodeParameters(url: baseVideoAPIURL, parameters: videoDetailsParemeters)
        
        URLSession.shared.dataTask(with: terminalURL)
        { (data, response, dataError) in
            completionHandler(data, response, dataError)
        }.resume()
    }
    
    static func downloadImageAt(imageURL: URL, _ completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)
    {
        URLSession.shared.dataTask(with: imageURL, completionHandler: completionHandler).resume()
    }
    
    static func downloadSongToServer(videoID: String, _ completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)
    {
        let APIRequestURL = URL(string: baseVideoDownloadURL.absoluteString + videoID)!
        URLSession.shared.dataTask(with: APIRequestURL, completionHandler: completionHandler).resume()
    }

    private static func encodeParameters(url input: URL, parameters : [String : String]) -> URL
    {
        let queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value ) }
        var components = URLComponents(string: input.absoluteString)
        components?.queryItems = queryItems
        guard let outputURL = components?.url else { fatalError("URL was unexpectedly nil")}
        
        return outputURL
    }
}

