//
//  TabViewController.swift
//  Canary
//
//  Created by Nifemi Fatoye on 24/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let veritcalFlowLayout = UICollectionViewFlowLayout()
        veritcalFlowLayout.scrollDirection = .vertical
        
        let homeViewController = HomeCollectionViewController(collectionViewLayout: veritcalFlowLayout)
        let searchViewController = SearchCollectionViewController(collectionViewLayout: veritcalFlowLayout)
        let libraryViewController = LibraryTableViewController()
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        
        homeNavigationController.tabBarItem.title = "Home"
        homeNavigationController.navigationItem.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(named: "HomeIcon")
        
        searchNavigationController.tabBarItem.title = "Search"
        searchNavigationController.navigationItem.title = "Search The Web"
        searchNavigationController.tabBarItem.image = UIImage(named: "SearchIcon")
        
        libraryNavigationController.tabBarItem.title = "Library"
        libraryNavigationController.navigationItem.title = "Your Music"
        libraryNavigationController.tabBarItem.image = UIImage(named: "LibraryIcon")
        
        let navigationControllers : [UINavigationController] = [homeNavigationController,searchNavigationController,libraryNavigationController]
        
        for navigationController in navigationControllers
        {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.montserratBold.withSize(35)]
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratMedium.withSize(10)], for: .normal)
        }
        
        viewControllers = navigationControllers
    }
}
