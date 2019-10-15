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
    static let baseSearchURL : URL = URL(string: "https://www.googleapis.com/youtube/v3?part=snippet")!
    static let baseVideoURL : URL = URL(string: "https://www.googleapis.com/youtube/v3/videos?&part=contentDetails")!
    
    static func getVideosFor(query input: String, parameters : [String : Any])
    {
        
    }
    
    static func getDetailsFor(videoID: String)
    {
        
    }
    
    private func encodeToURL(baseURL: URL, keyValues : [String : Any]) -> URL
    {
        
        
        
        return URL(fileURLWithPath: <#T##String#>)
    }
}
