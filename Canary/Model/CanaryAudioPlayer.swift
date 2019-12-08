//
//  AudioPlayer.swift
//  Canary
//
//  Created by Nifemi Fatoye on 06/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import Foundation
import MediaPlayer

protocol CanaryAudioPlayerDelegate : class
{
    func songWillBeginPlaying(song: Song, from playlist: Playlist)
}

class CanaryAudioPlayer
{
    static let audioSession = AVAudioSession.sharedInstance()
    static let player = AVPlayer()
    static var currentlyPlaying : (song : Song?, playlist : Playlist?)
    
    weak static var delegate : CanaryAudioPlayerDelegate?
    
    static func play(_ song: Song, from playlist: Playlist)
    {
        let asset = AVAsset(url: song.getAudioFilePath())
        let item = AVPlayerItem(asset: asset)
        
        do
        {
            try audioSession.setCategory(.playback)
            
            player.replaceCurrentItem(with: item)
            currentlyPlaying.song = song
            currentlyPlaying.playlist = playlist
            delegate?.songWillBeginPlaying(song: song, from: playlist)
            player.play()
        }
        catch
        {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
}
