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
        
        let homeViewController = HomeCollectionViewController(collectionViewLayout: .verticalFlow)
        let searchViewController = SearchCollectionViewController(collectionViewLayout: .verticalFlow)
        let libraryViewController = LibraryTableViewController()
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        
        homeNavigationController.tabBarItem.title = "Home"
        homeViewController.navigationItem.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(named: "HomeIcon")
        
        searchNavigationController.tabBarItem.title = "Search"
        searchViewController.navigationItem.title = "Search The Web"
        searchNavigationController.tabBarItem.image = UIImage(named: "SearchIcon")
        
        libraryNavigationController.tabBarItem.title = "Library"
        libraryViewController.navigationItem.title = "Your Music"
        libraryNavigationController.tabBarItem.image = UIImage(named: "LibraryIcon")
        
        let navigationControllers : [UINavigationController] = [homeNavigationController,searchNavigationController,libraryNavigationController]
        
        for navigationController in navigationControllers
        {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dynamicTextColor, NSAttributedString.Key.font: UIFont.montserratBold.withSize(35)]
            navigationController.navigationBar.backgroundColor = UIColor.systemBackground
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratMedium.withSize(12)], for: .normal)
        }
        
        viewControllers = navigationControllers
    }
}
