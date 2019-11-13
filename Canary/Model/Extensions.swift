//
//  Extensions.swift
//  Canary
//
//  Created by Nifemi Fatoye on 25/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

extension UIFont
{
    static let montserratLight = UIFont(name: "Montserrat-Light", size: 15)!
    static let montserratMedium = UIFont(name: "Montserrat-Medium", size: 15)!
    static let montserratBold = UIFont(name: "Montserrat-Bold", size: 15)!
}

extension UIColor
{
    static let dynamicTextColor = UIColor(named: "AdaptableTextColour")!
    static let dynamicCellColor = UIColor(named: "AdaptableCellColour")!
    static var globalTintColor = UIColor.systemBlue
}

extension UIImage
{
    static let homeIcon = UIImage(systemName: "music.house.fill")
    static let searchIcon = UIImage(systemName: "magnifyingglass")
    static let libraryIcon = UIImage(systemName: "rectangle.stack.fill")
    static let userIcon = UIImage(systemName: "person.crop.circle")
    static let downloadIcon = UIImage(systemName: "square.and.arrow.down.fill")
    static let addPlaylistIcon = UIImage(systemName: "rectangle.stack.fill.badge.plus")
    static let ellipsisIcon = UIImage(systemName: "ellipsis")
}

extension UIView
{
    func highlightBorders()
    {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.red.cgColor
    }
}

extension String
{
    var fullRange : NSRange
    {
        get
        {
            return NSRange(location: 0, length: self.count)
        }
    }
}

extension UICollectionViewLayout
{
    static let verticalFlow : UICollectionViewFlowLayout =
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
}

extension CGSize
{
    static let songCellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 75)
}
