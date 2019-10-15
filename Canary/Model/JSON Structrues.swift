//
//  JSON Structrues.swift
//  Canary
//
//  Created by Nifemi Fatoye on 15/10/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation

struct SearchListResponse: Decodable
{
    let items : [searchResult]
}

struct searchResult: Decodable
{
    let id : [String : String]
    let snippet : videoDetails
}

struct videoDetails: Decodable
{
    let title : String
}
