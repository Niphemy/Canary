//
//  SongSearchResultCollectionViewCell.swift
//  Canary
//
//  Created by Nifemi Fatoye on 28/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import CoreData

class SongSearchResultCollectionViewCell: SongCollectionViewCell
{
    private let loadingImageView = LoadingView()
    private let loadingDetailsLabel = LoadingView()
    private let loadingDynamicButton = LoadingView()
    private let downloadProgressView = UIView()
    private let context : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let sectorLayer = CAShapeLayer()
    private var mediaID = String()
    private var downloadProgessObserver: NSKeyValueObservation?

    deinit
    {
        downloadProgessObserver?.invalidate()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupLoadingImageView()
        setupLoadingDetailsLabel()
        setupLoadingDynamicButton()
        setupDownloadProgressView()
        
        dynamicButton.imageView?.contentMode = .scaleAspectFit
        dynamicButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        dynamicButton.setImage(UIImage.downloadIcon?.withTintColor(UIColor.globalTintColor).withConfiguration(UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        dynamicButton.isHidden = true
    }
    
    private func setupLoadingImageView()
    {
        imageView.addSubview(loadingImageView)
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        loadingImageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        loadingImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        loadingImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    private func setupLoadingDetailsLabel()
    {
        detailsLabel.addSubview(loadingDetailsLabel)
        loadingDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingDetailsLabel.heightAnchor.constraint(equalTo: detailsLabel.heightAnchor, multiplier: 0.6).isActive = true
        loadingDetailsLabel.leadingAnchor.constraint(equalTo: detailsLabel.leadingAnchor).isActive = true
        loadingDetailsLabel.trailingAnchor.constraint(equalTo: detailsLabel.trailingAnchor).isActive = true
        loadingDetailsLabel.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor).isActive = true
        loadingDetailsLabel.layer.cornerRadius = 8
    }
    
    private func setupLoadingDynamicButton()
    {
        dynamicButton.addSubview(loadingDynamicButton)
        loadingDynamicButton.translatesAutoresizingMaskIntoConstraints = false
        loadingDynamicButton.heightAnchor.constraint(equalTo: dynamicButton.heightAnchor).isActive = true
        loadingDynamicButton.leadingAnchor.constraint(equalTo: dynamicButton.leadingAnchor).isActive = true
        loadingDynamicButton.trailingAnchor.constraint(equalTo: dynamicButton.trailingAnchor).isActive = true
        loadingDynamicButton.centerYAnchor.constraint(equalTo: dynamicButton.centerYAnchor).isActive = true
        loadingDynamicButton.layer.cornerRadius = 8
    }
    
    private func setupDownloadProgressView()
    {
        contentView.insertSubview(downloadProgressView, belowSubview: dynamicButton)
        downloadProgressView.translatesAutoresizingMaskIntoConstraints = false
        downloadProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        downloadProgressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        downloadProgressView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
        downloadProgressView.widthAnchor.constraint(equalTo: downloadProgressView.heightAnchor).isActive = true
        downloadProgressView.isUserInteractionEnabled = true
        contentView.layoutIfNeeded()
    }
    
    private func setupLoadingAnimations()
    {
        dynamicButton.isEnabled = false
        
        let downloadProgressViewCenter = downloadProgressView.convert(downloadProgressView.center, from: contentView)
        let radius = downloadProgressView.frame.width/2 - 2
        let sectorPath = UIBezierPath(arcCenter: downloadProgressViewCenter, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        
        sectorLayer.path = sectorPath.cgPath
        sectorLayer.fillColor = UIColor.clear.cgColor
        sectorLayer.lineCap = .round
        sectorLayer.strokeColor = UIColor.globalTintColor.cgColor
        sectorLayer.lineWidth = 3
        sectorLayer.strokeEnd = 1/3
        
        let spinningAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinningAnimation.fromValue = 0
        spinningAnimation.toValue = 2*CGFloat.pi
        spinningAnimation.duration = 1
        spinningAnimation.repeatCount = .infinity
        
        downloadProgressView.layer.addSublayer(sectorLayer)
        downloadProgressView.layer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        downloadProgressView.layer.add(spinningAnimation, forKey: nil)
    }
    
    override func dynamicButtonTappedAction()
    {
        setupLoadingAnimations()
        
        let components = self.detailsLabel.text!.components(separatedBy: "\n")
        let durationString = self.durationLabel.text!
        let songDetails : (name: String, artists: String) = (components[0], components.count > 1 ? components[1] : "")
        let imagePngData = imageView.image?.pngData()
        
        YTAPI.downloadSongToServer(videoID: mediaID)
        { (data, response, dataError) in
            guard dataError == nil else { fatalError(dataError!.localizedDescription) }
            guard let data = data else { fatalError("No received data") }
            
            do
            {
                let APIResponse = try JSONDecoder().decode(VideoDownloadResponse.self, from: data)
                
                if !APIResponse.error
                {
                    let songURL = URL(string: "https://59ef3762.ngrok.io/phptutorial/download/\(self.mediaID).mp3")!
                    
                    DispatchQueue.main.async
                    {
                        self.downloadProgressView.layer.removeAllAnimations()
                        self.sectorLayer.strokeEnd = 0
                    }
                    
                    let downloadTask = URLSession.shared.downloadTask(with: songURL)
                    { (location, response, downloadError) in
                        guard let location = location, downloadError == nil else { return }
                         
                        do
                        {
                            
                            let newSong = Song(context: self.context)
                            newSong.setDetails(id: self.mediaID, artists: songDetails.artists, name: songDetails.name, date: Date(timeIntervalSinceNow: 0), duration: durationString)
                            try FileManager.default.moveItem(at: location, to: newSong.getAudioFilePath())
                            self.downloadSongImage(imageDestination: newSong.getImageFilePath(), imageData: imagePngData)
                            self.saveSongs()
                            //Asynchronous task ends here.
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    
                    self.downloadProgessObserver = downloadTask.progress.observe(\.fractionCompleted)
                    { downloadProgress, _ in
                        DispatchQueue.main.async
                        {
                            self.sectorLayer.strokeEnd = CGFloat(downloadProgress.fractionCompleted)
                            if downloadProgress.fractionCompleted == 1
                            {
                                self.downloadProgessObserver = nil
                            }
                        }
                    }
                    
                    downloadTask.resume()
                }
                else
                {
                    print("no video found")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
    
    private func downloadSongImage(imageDestination: URL, imageData: Data?)
    {
        do
        {
            try imageData?.write(to: imageDestination)
        }
        catch{return}
    }
    
    public func setDisplayInfo(with searchResult: SongSearchResult)
    {
        if searchResult.hasLoaded
        {
            setDisplayData(image: searchResult.getImage()!, name: searchResult.getName()!, artists: searchResult.getArtists()!, duration: searchResult.getDuration()!)
            mediaID = searchResult.getMediaID()
            loadingImageView.isHidden = true
            loadingDetailsLabel.isHidden = true
            loadingDynamicButton.isHidden = true
            dynamicButton.isHidden = false
        }else{
            imageView.image = nil
            detailsLabel.text = nil
            durationLabel.text = nil
            loadingImageView.isHidden = false
            loadingDetailsLabel.isHidden = false
            loadingDynamicButton.isHidden = false
            dynamicButton.isHidden = true
        }
    }
    
    func saveSongs()
    {
        do
        {
            try context.save()
        } catch {
            print("Error saving context:\n\(error)")
        }
    }
}
