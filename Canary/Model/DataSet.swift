//
//  DataSet.swift
//  test
//
//  Created by Nifemi Fatoye on 27/08/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

struct DataSet
{
    var values : [Int]
    var colours : [UIColor]
    var count : Int
    
    init()
    {
        self.values = [Int]()
        self.colours = [UIColor]()
        self.count = Int()
    }
    
    init(_ data: [(value: Int,colour: UIColor)])
    {
        self.init()
        
        for set in data
        {
            values.append(set.value)
            colours.append(set.colour)
        }
        self.count = data.count
    }
}
