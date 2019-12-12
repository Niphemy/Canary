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
    private let player = AVPlayer()
    private let notificationCenter: NotificationCenter
    var currentlyPlaying : (song : Song?, playlist : Playlist?)
    var playlistItems : [PlaylistItem] = []
    var futureItems : [PlaylistItem] = []
    var currentIndex = 0
    
    weak var delegate : CanaryAudioPlayerDelegate?
    
    init()
    {
        notificationCenter = NotificationCenter.default
        do{try AVAudioSession.sharedInstance().setCategory(.playback)}catch{fatalError("Could set audioSession")}
        
        player.actionAtItemEnd = .pause
        
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget
        { (event) -> MPRemoteCommandHandlerStatus in
            let event = event as? MPChangePlaybackPositionCommandEvent
            let seekTime = CMTime(seconds: event!.positionTime, preferredTimescale: 10)
            self.player.seek(to: seekTime)
            return .success
        }
        
        MPRemoteCommandCenter.shared().playCommand.addTarget
        { (event) -> MPRemoteCommandHandlerStatus in
            self.resume()
            return .success
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget
        { (event) -> MPRemoteCommandHandlerStatus in
            self.pause()
            return .success
        }
    }
    
    func play(_ selectedSong: Song, from playlist: Playlist, songs: [Song])
    {
        currentIndex = 0
        
        if currentlyPlaying.playlist == playlist && songIsInFutureQueue(for: selectedSong)
        {
            
        }
        else
        {
            var newSongQueue = songs
            guard let indexOfSelectedSong = songs.firstIndex(of: selectedSong) else { return }
            newSongQueue.swapAt(0, indexOfSelectedSong)
            playlistItems = newSongQueue.map({ PlaylistItem(song: $0) })
            futureItems = Array(playlistItems.dropFirst(1))
        }
        
        currentlyPlaying.playlist = playlist
        handleAutomaticPlayback()
    }
    
    private func handleAutomaticPlayback()
    {
        let image = UIImage(contentsOfFile: playlistItems[currentIndex].song.getImageFilePath().path) ?? UIImage.defaultSongIcon.withTintColor(.globalTintColor)
        let artwork = MPMediaItemArtwork(boundsSize: image.size){_ in image }
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        NotificationCenter.default.addObserver(self, selector: #selector(songEnded), name: .AVPlayerItemDidPlayToEndTime, object: playlistItems[currentIndex].item)
        
        currentlyPlaying.song = playlistItems[currentIndex].song
        delegate?.songWillBeginPlaying(song: currentlyPlaying.song!, from: currentlyPlaying.playlist!)
        player.replaceCurrentItem(with: playlistItems[currentIndex].item)
        player.play()

        nowPlayingInfo[MPMediaItemPropertyTitle] = playlistItems[currentIndex].song.name
        nowPlayingInfo[MPMediaItemPropertyAssetURL] = playlistItems[currentIndex].song.getAudioFilePath()
        nowPlayingInfo[MPMediaItemPropertyArtist] = playlistItems[currentIndex].song.artists
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = 0
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playlistItems[currentIndex].asset.duration.seconds
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        notificationCenter.post(name: .SongChanged, object: nil)
    }
    
    @objc private func songEnded()
    {
        if currentIndex < playlistItems.endIndex - 1
        {
            currentIndex += 1
            futureItems.remove(at: 0)
            handleAutomaticPlayback()
        }
    }
    
    private func songIsInFutureQueue(for song : Song) -> Bool
    {
        return futureItems.contains
        { (item) -> Bool in
            if item.song == song
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    // must change currently playing
    // must call delegate
    // must finally play
    // update nowplaying info
    
    public func pause()
    {
        player.pause()
        handlePlaybackChange()
    }
    
    public func resume()
    {
        player.play()
        handlePlaybackChange()
    }
    
    private func handlePlaybackChange()
    {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentItem?.currentTime().seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}



