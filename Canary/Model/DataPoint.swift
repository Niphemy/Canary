//
//  DataPoint.swift
//  test
//
//  Created by Nifemi Fatoye on 21/01/2020.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

struct DataPoint
{
    let value : Float
    let colour : UIColor
    let title : String
    
    init(value : Float, colour : UIColor, title : String)
    {
        self.value = value
        self.colour = colour
        self.title = title
    }
}
