//
//  HomeCollectionViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 25/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

fileprivate let HSCreuseIdentifier = "StatisticsCell"
fileprivate let RreuseIdentifier = "RecommendCell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.collectionView!.register(HomeStatisticsCollectionViewCell.self, forCellWithReuseIdentifier: HSCreuseIdentifier)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: RreuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch indexPath
        {
        case [0,0]:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HSCreuseIdentifier, for: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RreuseIdentifier, for: indexPath)
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.homeCellSize
    }

}
