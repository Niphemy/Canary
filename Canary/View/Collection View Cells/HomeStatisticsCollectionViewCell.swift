//
//  HomeStatisticsCollectionViewCell.swift
//  Canary
//
//  Created by Nifemi Fatoye on 19/01/2020.
//  Copyright © 2020 Nifemi Fatoye. All rights reserved.
//

import Foundation
import UIKit

class HomeStatisticsCollectionViewCell : UICollectionViewCell
{
    let titleLabel = UILabel()
    let averageTimeLabel = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 1, height: 2)
        contentView.layer.cornerRadius = 17
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.dynamicCellColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
