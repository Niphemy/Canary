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
        
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.showsVerticalScrollIndicator = false
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HSCreuseIdentifier, for: indexPath)
            return cell
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.homeCellSize
    }
}
