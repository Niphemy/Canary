//
//  PlaylistItem.swift
//  Canary
//
//  Created by Nifemi Fatoye on 12/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import AVFoundation

struct PlaylistItem
{
    let asset : AVAsset
    let song : Song
    
    init(song : Song)
    {
        self.song = song
        self.asset = AVAsset(url: song.getAudioFilePath())
    }
}
