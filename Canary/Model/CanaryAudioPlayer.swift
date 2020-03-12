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

class CanaryAudioPlayer : NSObject, AVAudioPlayerDelegate
{
    private let notificationCenter: NotificationCenter = NotificationCenter.default
    private var player = AVAudioPlayer()
    private var playlistItems : [PlaylistItem] = []
    private var futureItems : [PlaylistItem]
    {
        get
        {
            return Array(playlistItems.dropFirst(currentIndex + 1))
        }
    }
    
    private var currentIndex = 0
    var currentlyPlaying : (song : Song?, playlist : Playlist?)
    
    var isPlaying : Bool
    {
        get
        {
            return player.isPlaying
        }
    }
    
    weak var delegate : CanaryAudioPlayerDelegate?
    
    override init()
    {
        super.init()
        
        do{try AVAudioSession.sharedInstance().setCategory(.playback)}catch{fatalError("Could set audioSession")}
        
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget
        { (event) -> MPRemoteCommandHandlerStatus in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {fatalError(" could not get event")}
            self.player.currentTime = event.positionTime
            return .success
        }
        
        MPRemoteCommandCenter.shared().playCommand.addTarget
        { (_) -> MPRemoteCommandHandlerStatus in
            self.resume()
            return .success
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget
        { (_) -> MPRemoteCommandHandlerStatus in
            self.pause()
            return .success
        }
        
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget
        { (_) -> MPRemoteCommandHandlerStatus in
            self.nextTrack()
            return .success
        }
        
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget
        { (_) -> MPRemoteCommandHandlerStatus in
            self.previousTrack()
            return .success
        }
        
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget
        { (_) -> MPRemoteCommandHandlerStatus in
            self.togglePlayPause()
            return .success
        }
    }
    
    func play(_ selectedSong: Song, from playlist: Playlist, songs: [Song])
    {
        let indexOfSelectedSong = songs.firstIndex(of: selectedSong)!
        
        playlistItems = songs.map({ PlaylistItem(song: $0) })
        currentIndex = indexOfSelectedSong
        currentlyPlaying.playlist = playlist
        
        if currentlyPlaying.playlist == playlist && songIsInFutureQueue(for: selectedSong)
        {
            currentIndex = playlistItems.firstIndex(where: { selectedSong == $0.song })!
        }
        
        handleAutomaticPlayback()
    }
    
    private func handleAutomaticPlayback()
    {
        let image = UIImage(contentsOfFile: playlistItems[currentIndex].song.getImageFilePath().path) ?? UIImage.defaultSongIcon.withTintColor(.globalTintColor)
        let artwork = MPMediaItemArtwork(boundsSize: image.size){_ in image }
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        currentlyPlaying.song = playlistItems[currentIndex].song
        delegate?.songWillBeginPlaying(song: currentlyPlaying.song!, from: currentlyPlaying.playlist!)
        
        do
        {
            player = try AVAudioPlayer(contentsOf: playlistItems[currentIndex].song.getAudioFilePath())
            player.delegate = self
        }
        catch
        {
            fatalError("could not create player")
        }
        
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if currentIndex < playlistItems.endIndex - 1
        {
            currentIndex += 1
            handleAutomaticPlayback()
        }
        handlePlaybackChange()
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
    
    public func nextTrack()
    {
        audioPlayerDidFinishPlaying(player, successfully: true)
    }
    
    public func previousTrack()
    {
        if player.currentTime < 3 && currentIndex > 0
        {
            currentIndex -= 1
        }
        
        handleAutomaticPlayback()
    }
    
    public func togglePlayPause()
    {
        if player.isPlaying
        {
            pause()
        }
        else
        {
            resume()
        }
    }
    
    public func currentTime() -> TimeInterval
    {
        return player.currentTime
    }
    
    public func currentDuration() -> TimeInterval
    {
        return player.duration
    }
    
    public func seekTo(time: TimeInterval)
    {
        player.currentTime = time
        handlePlaybackChange()
    }
    
    private func handlePlaybackChange()
    {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        notificationCenter.post(name: .PlaybackChanged, object: nil)
    }

}



