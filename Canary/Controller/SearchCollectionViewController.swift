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
        // #warning Incomplete implementation, return the number of items
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

extension SearchCollectionViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if let queryText = webSearchController.searchBar.text
        {
            print("does stuff with \(queryText)")
        }
    }
}
