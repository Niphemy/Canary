//
//  YTAPI.swift
//  Canary
//
//  Created by Nifemi Fatoye on 15/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation

struct YTAPI
{
    private static let baseAPIURL : URL = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    private static let APIKey : String = "AIzaSyD1RJzDF3fhadZzih0Lv0ZKGrLsDTINDFw"
    
    static func getResultsFor(query input: String, _ completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)
    {
        let videoSearchParameters : [String: String] = ["part":"snippet", "q":input, "type":"video", "videoCategoryId":"10", "relevanceLanguage":"en", "maxResults":"15", "key":APIKey]
        let terminalURL : URL = encodeParameters(url: baseAPIURL, parameters: videoSearchParameters)
        
        URLSession.shared.dataTask(with: terminalURL)
        { (data, response, dataError) in
            completionHandler(data, response, dataError)
        }.resume()
    }
    
    static func getDurationFor(videoID: String, _ completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)
    {
        let videoDetailsParemeters : [String: String] = ["part":"contentDetails","id":videoID , "key":APIKey]
        let terminalURL : URL = encodeParameters(url: baseAPIURL, parameters: videoDetailsParemeters)
        
        URLSession.shared.dataTask(with: terminalURL)
        { (data, response, dataError) in
            completionHandler(data, response, dataError)
        }.resume()
    }
    
    private static func encodeParameters(url input: URL, parameters : [String : String]) -> URL
    {
        let queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value ) }
        var components = URLComponents(string: baseAPIURL.absoluteString)
        components?.queryItems = queryItems
        guard let outputURL = components?.url else { fatalError("URL was unexpectedly nil")}
        
        return outputURL
    }
}

