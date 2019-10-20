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
        // Register cell classes
        self.collectionView!.register(SongSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.systemBackground
        webSearchController.searchBar.autocapitalizationType = .words
        webSearchController.searchBar.delegate = self 
        
        self.navigationItem.searchController = webSearchController
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
    
        // Configure the cell
        let tempSearchResult = searchResults[indexPath.item]
        cell.setDisplayInfo(with: tempSearchResult)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.songCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension SearchCollectionViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if let queryText = webSearchController.searchBar.text
        {
            YTAPI.getResultsFor(query: queryText, handleSearchListResponse(_:_:_:))
            webSearchController.isActive = false
        }
    }
}

// MARK: - Networking

extension SearchCollectionViewController
{
    func handleSearchListResponse(_ data: Data?, _ response: URLResponse?, _ dataError: Error?)
    {
        searchResults.removeAll()
        guard dataError == nil else { fatalError(dataError!.localizedDescription) }
        guard let data = data else { fatalError("No received data") }
        
        do
        {
            let APIResponse = try JSONDecoder().decode(SearchListResponse.self, from: data)
            
            for item in APIResponse.items
            {
                let tempResult : SongSearchResult = SongSearchResult(mediaID: item.id.videoId)
                tempResult.setDetailsFrom(youtubeTitle: item.snippet.title)
                searchResults.append(tempResult)
                DispatchQueue.main.async { self.collectionView.reloadData() }
                
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func handleVideoListResponse(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
}
