//
//  VideoListResponse.swift
//  Canary
//
//  Created by Nifemi Fatoye on 20/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation

struct VideoListResponse: Decodable
{
    let items : [video]
    
    struct video: Decodable
    {
        let contentDetails: videoInformation
        
        struct videoInformation: Decodable
        {
            let id : String
        }
    }
}
