//
//  BarChartView2.swift
//  Canary
//
//  Created by Nifemi Fatoye on 21/01/2020.
//  Copyright © 2020 Nifemi Fatoye. All rights reserved.
//

import UIKit

class BarChartView2: UIView
{
    private let chartData : [DataPoint]
    private let spacing : CGFloat
    private let stepLineCount : Int
    private let chartColour : UIColor
    private let graphInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20)
    
    private var numberOfBars : Int
    {
        get
        {
            return chartData.count
        }
    }
    
    private var barWidth : CGFloat
    {
        get
        {
            return (bounds.width - CGFloat(numberOfBars+1)*spacing)/CGFloat(numberOfBars)
        }
    }
    
    private var chartSize : CGSize
    {
        get
        {
            return CGSize(width: bounds.width - graphInsets.right, height: bounds.height - graphInsets.bottom)
        }
    }
    
    init(chartData : [DataPoint], barSpacing : CGFloat, stepLineCount : Int, chartColour : UIColor = .white)
    {
        self.chartData = chartData
        self.spacing = barSpacing
        self.stepLineCount = stepLineCount
        self.chartColour = chartColour
        
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChart()
    {
        let axisLabelAttribues : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratLight, NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        let bottomLeft = CGPoint(x: 0, y: bounds.maxY - graphInsets.bottom)
        let bottomRight = CGPoint(x: bounds.maxX - graphInsets.right, y: bounds.maxY - graphInsets.bottom)
        
        let xAxis = UIBezierPath()
        xAxis.move(to: bottomLeft)
        xAxis.addLine(to: bottomRight)
        
        let xAxisLayer = CAShapeLayer()
        xAxisLayer.path = xAxis.cgPath
        xAxisLayer.lineWidth = 2
        xAxisLayer.strokeColor = chartColour.cgColor
        xAxisLayer.lineCap = .round
        layer.addSublayer(xAxisLayer)
        
        let zeroLabel = UILabel()
        addSubview(zeroLabel)
        zeroLabel.center.x = bottomRight.x + graphInsets.right/2
        zeroLabel.center.y = bottomLeft.y
        zeroLabel.bounds.size = CGSize(width: 20, height: 20)
        
        zeroLabel.attributedText = NSAttributedString(string: "0", attributes: axisLabelAttribues)
        zeroLabel.textAlignment = .center
        
        for i in 1...stepLineCount
        {
            let yCoord : CGFloat = chartSize.height - CGFloat(i)/CGFloat(stepLineCount)*chartSize.height
            let startPoint = CGPoint(x: 0, y: yCoord)
            let endPoint = CGPoint(x: bottomRight.x, y: yCoord)
            
            let stepLine = UIBezierPath()
            stepLine.move(to: startPoint)
            stepLine.addLine(to: endPoint)
            
            let stepLayer = CAShapeLayer()
            stepLayer.path = stepLine.cgPath
            stepLayer.lineWidth = 0.5
            stepLayer.strokeColor = chartColour.cgColor
            stepLayer.lineCap = .round
            stepLayer.lineDashPattern = [2,2]
            layer.addSublayer(stepLayer)
            
            let axesLabel = UILabel()
            addSubview(axesLabel)
            axesLabel.center.x = endPoint.x + graphInsets.right/2
            axesLabel.center.y = yCoord
            axesLabel.bounds.size = CGSize(width: 20, height: 20)
            
            axesLabel.attributedText = NSAttributedString(string: "\(i)", attributes: axisLabelAttribues)
            axesLabel.textAlignment = .center
        }
        
    }
    
    override func layoutSubviews()
    {
        setupChart()
    }
}
