//
//  PieChartView.swift
//  test
//
//  Created by Nifemi Fatoye on 10/08/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class PieChartView : UIView
{
    //MARK: - Variable Initialisation
    
    private let chartData : [DataPoint]
    private let values : [Float]
    
    private var numberOfSectors : Int
    {
        get
        {
            return values.count
        }
    }
    
    public var dataTotal : Float
    {
        get
        {
            return values.reduce(0, +)
        }
    }
    
    private var calculatedRadius : CGFloat
    {
        get
        {
            layoutIfNeeded()
            return min(bounds.width, bounds.height)/2
        }
    }
    
    private let colourScheme : [UIColor]
    
    public func getMostPlayed() -> (String, Float)?
    {
        if dataTotal != 0
        {
            guard let artistNameIndex = chartData.firstIndex(where: { $0.value == values.last}) else { return nil }
            
            return (chartData[artistNameIndex].title, chartData[artistNameIndex].value)
        }
        else
        {
            return nil
        }
    }
    
    //MARK: - Initialisers
    
    required init?(coder aDecoder: NSCoder)
    {
        self.chartData = [DataPoint]()
        self.values = [Float]()
        self.colourScheme = [UIColor]()
        
        super.init(coder: aDecoder)
    }
    
    init()
    {
        self.chartData = [DataPoint]()
        self.values = [Float]()
        self.colourScheme = [UIColor]()
        
        super.init(frame: CGRect())
    }
    
    init(chartData : [DataPoint])
    {
        self.chartData = chartData
        self.values = chartData.map({ $0.value }).sorted()
        var colours = Array(repeating: UIColor.globalTintColor, count: chartData.count)
        colours[colours.count - 1] = UIColor.red
    
        self.colourScheme = colours
        super.init(frame: CGRect())
    }
    
    //MARK: - Draw Chart Functions
    
    override func layoutSubviews()
    {
        if dataTotal != 0
        {
            drawPieChart()
        }
    }
    
    private func drawPieChart()
    {
        var cumulativeValue : Float = 0
        self.layer.sublayers = nil
        layoutIfNeeded()
        
        for i in 0..<numberOfSectors
        {
            let sectorLayer : CAShapeLayer = CAShapeLayer()
            
            let cumulativeProportion : CGFloat = CGFloat(values[i] + cumulativeValue) / CGFloat(dataTotal)
            let calculatedEndAngle : CGFloat = -0.5*CGFloat.pi + (2 * CGFloat.pi * cumulativeProportion)
            let sectorFractionPath : UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: calculatedRadius/2, startAngle: -0.5*CGFloat.pi, endAngle: calculatedEndAngle, clockwise: true)
            cumulativeValue += values[i]
            
            sectorLayer.fillColor = UIColor.clear.cgColor
            sectorLayer.lineWidth = calculatedRadius
            sectorLayer.strokeColor = colourScheme[i].cgColor
            sectorLayer.path = sectorFractionPath.cgPath
            sectorLayer.zPosition = CGFloat(numberOfSectors - i).advanced(by: 1)
            
            self.layer.addSublayer(sectorLayer)
        }
    }
}


