//
//  SearchListResponse.swift
//  Canary
//
//  Created by Nifemi Fatoye on 15/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation

struct SearchListResponse: Decodable
{
    let items : [searchResult]
    
    struct searchResult: Decodable
    {
        let id : identifier
        
        struct identifier: Decodable
        {
            let videoId : String
        }
        
        let snippet : videoDetails
        
        struct videoDetails: Decodable
        {
            let title : String
            let thumbnails : thumbnailURLs
            
            struct thumbnailURLs: Decodable
            {
                let high : highThumbnailURL
                let medium : mediumThumbnailURL
                let `default` : defaultThumbnailURL
                //default is a keyword in swift so it must be quoted in backticks to ignore the swift syntax in this case
                
                struct highThumbnailURL: Decodable
                {
                    let url : String
                }

                struct mediumThumbnailURL: Decodable
                {
                    let url : String
                }

                struct defaultThumbnailURL: Decodable
                {
                    let url : String
                }
            }
        }
    }
}

