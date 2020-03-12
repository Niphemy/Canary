//
//  BarChartView.swift
//  Canary
//
//  Created by Nifemi Fatoye on 21/01/2020.
//  Copyright © 2020 Nifemi Fatoye. All rights reserved.
//

import UIKit

class BarChartView: UIView
{
    private let chartData : [DataPoint]
    private let spacing : CGFloat
    private let stepLineCount : Int
    private let chartColour : UIColor
    private let graphInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20)
    private let barContainer = CALayer()
    private let labelAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratLight, NSAttributedString.Key.foregroundColor : UIColor.systemGray]
    
    private var numberOfBars : Int
    {
        get
        {
            return chartData.count
        }
    }
    
    private var averageValue : Float
    {
        get
        {
            var values = chartData.map({ $0.value })
            var endCase = true
            
            while endCase
            {
                for i in 0..<values.count
                {
                    if values[i] == 0
                    {
                        values.remove(at: i)
                        break
                    }
                    
                    if i == values.count - 1
                    {
                        endCase = false
                    }
                }
            }
            
            return values.reduce(0, +)/Float(values.count)
        }
    }
    
    private var stepSize : Int
    {
        let maxDataPoint = chartData.map({ $0.value }).max()
        
        let tempStep : Float = maxDataPoint! / Float(stepLineCount)
        let mag : Float = floor(log10(tempStep))
        let magPow : Float = pow(10, mag)
        var magMsd : Float = (tempStep / magPow + 0.5)
        
        if magMsd > 5
        {
            magMsd = 10
        }
        else if magMsd > 2
        {
            magMsd = 5
        }
        else if magMsd > 1
        {
            magMsd = 2
        }
        return Int(magMsd * magPow)
    }
    
    init(chartData : [DataPoint], barSpacing : CGFloat, stepLineCount : Int, chartColour : UIColor = .white)
    {
        var convertedChartData = [DataPoint]()

        for dataPoint in chartData
        {
            let newPoint = DataPoint(value: dataPoint.value/60, colour: dataPoint.colour, title: dataPoint.title)
            convertedChartData.append(newPoint)
        }

        self.chartData = convertedChartData
        self.spacing = barSpacing
        self.stepLineCount = stepLineCount
        self.chartColour = chartColour
        
        super.init(frame: CGRect())
        layer.addSublayer(barContainer)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAxes()
    {
        let bottomLeft = CGPoint(x: 0, y: bounds.maxY - graphInsets.bottom)
        let bottomRight = CGPoint(x: bounds.maxX - graphInsets.right, y: bounds.maxY - graphInsets.bottom)
        
        let xAxis = UIBezierPath()
        xAxis.move(to: bottomLeft)
        xAxis.addLine(to: bottomRight)
        
        let xAxisLayer = CAShapeLayer()
        xAxisLayer.path = xAxis.cgPath
        xAxisLayer.lineWidth = 2
        xAxisLayer.strokeColor = UIColor.systemGray.cgColor
        xAxisLayer.lineCap = .round
        layer.insertSublayer(xAxisLayer, above: barContainer)
        
        let zeroLabel = UILabel()
        addSubview(zeroLabel)
        zeroLabel.center.x = bottomRight.x + graphInsets.right/2
        zeroLabel.center.y = bottomLeft.y
        zeroLabel.bounds.size = CGSize(width: 40, height: 20)
        
        zeroLabel.attributedText = NSAttributedString(string: "0m", attributes: labelAttributes)
        zeroLabel.textAlignment = .right
        
        for i in 1...stepLineCount
        {
            let yCoord : CGFloat = (bounds.height - graphInsets.bottom) - CGFloat(i)/CGFloat(stepLineCount)*(bounds.height - graphInsets.bottom)
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
            layer.insertSublayer(stepLayer, below: barContainer)
            
            let axesLabel = UILabel()
            addSubview(axesLabel)
            axesLabel.center.x = endPoint.x + graphInsets.right
            axesLabel.center.y = yCoord
            axesLabel.bounds.size = CGSize(width: 40, height: 20)
            
            axesLabel.attributedText = NSAttributedString(string: "\(stepSize*i)m", attributes: labelAttributes)
            axesLabel.textAlignment = .center
        }
        
    }
    
    private func drawDataPoints()
    {
        barContainer.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - graphInsets.right, height: bounds.height))
        let barWidth = (barContainer.bounds.width - CGFloat(numberOfBars+1)*spacing)/CGFloat(numberOfBars)
        let barLabelAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratRegular, NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor]
        
        for i in 0..<numberOfBars
        {
            let barLabel = UILabel()
            addSubview(barLabel)
            let barLabelOrigin = CGPoint(x: CGFloat(i+1)*spacing + CGFloat(i)*barWidth, y: barContainer.frame.height - graphInsets.bottom)
            barLabel.frame = CGRect(origin: barLabelOrigin, size: CGSize(width: barWidth, height: graphInsets.bottom))
            barLabel.textAlignment = .center
            barLabel.attributedText = NSAttributedString(string: chartData[i].title, attributes: barLabelAttributes)
            
            let barSize = CGSize(width: barWidth, height: CGFloat(chartData[i].value/Float(stepLineCount*stepSize))*(barContainer.bounds.height - graphInsets.bottom))
            let barOrigin = CGPoint(x: CGFloat(i+1)*spacing + CGFloat(i)*barWidth, y: barContainer.frame.height - (graphInsets.bottom+barSize.height))
            let barFrame = CGRect(origin: barOrigin, size: barSize)
            
            let barPath = UIBezierPath(roundedRect: barFrame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
            let barLayer = CAShapeLayer()
            barLayer.path = barPath.cgPath
            barLayer.fillColor = chartData[i].colour.cgColor
            
            barContainer.addSublayer(barLayer)
        }
    
        let yCoord = barContainer.frame.height - graphInsets.bottom - CGFloat(averageValue/Float(stepLineCount*stepSize))*(barContainer.bounds.height - graphInsets.bottom)
        
        let startPoint = CGPoint(x: 0, y: yCoord)
        let endPoint = CGPoint(x: barContainer.bounds.maxX, y: yCoord)
        
        let averageLinePath = UIBezierPath()
        averageLinePath.move(to: startPoint)
        averageLinePath.addLine(to: endPoint)
        
        let averageLineLayer = CAShapeLayer()
        averageLineLayer.path = averageLinePath.cgPath
        averageLineLayer.lineWidth = 1
        averageLineLayer.strokeColor = UIColor.green.cgColor
        averageLineLayer.lineCap = .round
        averageLineLayer.lineDashPattern = [2,2]
        
        let averageLabel = UILabel()
        addSubview(averageLabel)
        averageLabel.center.x = (bounds.maxX - graphInsets.right) + graphInsets.right
        averageLabel.center.y = barContainer.frame.height - graphInsets.bottom - CGFloat(averageValue/Float(stepLineCount*stepSize))*(barContainer.bounds.height - graphInsets.bottom)
        averageLabel.bounds.size = CGSize(width: 30, height: 20)
        
        averageLabel.textAlignment = .left
        let averageLabelAttribues : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratLight, NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        averageLabel.attributedText = NSAttributedString(string: "avg", attributes: averageLabelAttribues)
        
        barContainer.addSublayer(averageLineLayer)
    }
    
    override func layoutSubviews()
    {
        if averageValue != 0
        {
            setupAxes()
            drawDataPoints()
        }
    }
}

