//
//  Extensions.swift
//  Canary
//
//  Created by Nifemi Fatoye on 25/09/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

extension UIColor
{
    static let mainBlue = UIColor.init(hex: "007AFF")
    
    public convenience init?(hex: String)
    {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#")
        {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8
            {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber)
                {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIFont
{
    static let montserratLight = UIFont(name: "Montserrat-Light", size: 15)!
    static let montserratMedium = UIFont(name: "Montserrat-Medium", size: 15)!
    static let montserratBold = UIFont(name: "Montserrat-Bold", size: 15)!
}
