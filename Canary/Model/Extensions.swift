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
