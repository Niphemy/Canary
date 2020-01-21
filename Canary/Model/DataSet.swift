//
//  DataSet.swift
//  test
//
//  Created by Nifemi Fatoye on 27/08/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

struct DataPoint
{
    let value : Int
    let colour : UIColor
    let title : String
    
    init(value : Int, colour : UIColor, title : String)
    {
        self.value = value
        self.colour = colour
        self.title = title
    }
}
