//
//  SearchCollectionViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 24/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchResultCell"

class SearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    let webSearchController : UISearchController = UISearchController()
    var searchResults : [SongSearchResult] = [SongSearchResult]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionView!.register(SongSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
        webSearchController.searchBar.autocapitalizationType = .words
        webSearchController.searchBar.delegate = self 
        
        self.navigationItem.searchController = webSearchController
        self.collectionView.showsVerticalScrollIndicator = false
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return searchResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongSearchResultCollectionViewCell
        
        cell.delegate = self
        cell.reloadCell()
        
        let tempSearchResult = searchResults[indexPath.item]
        cell.setDisplayInfo(with: tempSearchResult)
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension SearchCollectionViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if let queryText = webSearchController.searchBar.text
        {
            searchResults.removeAll()
            
            collectionView.reloadData()
            YTAPI.getResultsFor(query: queryText, handleSearchListResponse(_:_:_:))
            webSearchController.isActive = false
        }
    }
}

// MARK: - Networking

extension SearchCollectionViewController
{
    func handleSearchListResponse(_ data: Data?, _: URLResponse?, _ dataError: Error?)
    {
        guard dataError == nil else { fatalError(dataError!.localizedDescription) }
        guard let data = data else { fatalError("No received data") }
        
        do
        {
            let APIResponse = try JSONDecoder().decode(SearchListResponse.self, from: data)
            
            for item in APIResponse.items
            {
                let tempResult : SongSearchResult = SongSearchResult(mediaID: item.id.videoId)
                let thumbnailURL : URL = URL(string: item.snippet.thumbnails.medium.url)!
                tempResult.setDetailsFrom(youtubeTitle: item.snippet.title)
                searchResults.append(tempResult)
                
                YTAPI.downloadImageAt(imageURL: thumbnailURL)
                { (imageData, imageResponse, imageError) in
                    guard imageError == nil else { print(imageError!.localizedDescription); return }
                    guard let imageData = imageData else { return }
                    tempResult.setImage(to: UIImage(data: imageData) ?? UIImage.defaultSongIcon)
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
                
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }
            YTAPI.getDurationFor(searchResults: searchResults, handleVideoListResponse(_:_:_:))
        }
        catch
        {
            print(error)
        }
    }
    
    func handleVideoListResponse(_ data: Data?, _: URLResponse?, _ dataError: Error?)
    {
        guard dataError == nil else { fatalError(dataError!.localizedDescription) }
        guard let data = data else { fatalError("No received data") }
        
        do
        {
            let APIResponse = try JSONDecoder().decode(VideoListResponse.self, from: data)
            
            for item in APIResponse.items
            {
                let searchResultIndex = searchResults.firstIndex(where: { $0.getMediaID() == item.id })!
                searchResults[searchResultIndex].setDuration(to: item.contentDetails.duration)
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }
        }
        catch
        {
            print(error)
        }
    }
}

extension SearchCollectionViewController: SongSearchResultCollectionViewCellDelegate
{
    func songDownloadDidError()
    {
        DispatchQueue.main.async
        {
            let videoDownloadErrorAlert = UIAlertController(title: "Song failed to download", message: nil, preferredStyle: .alert)
            
            self.present(videoDownloadErrorAlert, animated: true, completion:
            {
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats:false, block:
                {_ in
                    videoDownloadErrorAlert.dismiss(animated: true, completion: nil)
                })
            })
            
            self.collectionView.reloadData()
        }
    }
    
    func songDownloadDidSucceed()
    {
        DispatchQueue.main.async
        {
            let videoDownloadSuccessAlert = UIAlertController(title: "Song was added to All Downloads", message: nil, preferredStyle: .alert)
            
            self.present(videoDownloadSuccessAlert, animated: true, completion:
            {
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats:false, block:
                {_ in
                    videoDownloadSuccessAlert.dismiss(animated: true, completion: nil)
                })
            })
            
            self.collectionView.reloadData()
        }
    }
}
