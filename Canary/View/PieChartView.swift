//
//  PieChartView.swift
//  test
//
//  Created by Nifemi Fatoye on 10/08/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
/*
class PieChartView : UIView
{
    //MARK: - Variable Initialisation
    
    private let chartData : DataSet
    private let numberOfSectors : Int
    private let dataTotal : Int
    private let calculatedRadius : CGFloat
    private let colourScheme : [UIColor] = [UIColor.gray,UIColor.green,UIColor.red]
    
    //MARK: - Initialisers
    
    required init?(coder aDecoder: NSCoder)
    {
        self.chartData = DataSet()
        self.numberOfSectors = Int()
        self.dataTotal = Int()
        self.calculatedRadius = CGFloat()
        
        super.init(coder: aDecoder)
    }
    
    init(chartData : DataSet, parentView : UIView)
    {
        let frame = parentView.convert(parentView.frame, from: parentView.superview)

        self.chartData = chartData
        self.numberOfSectors = chartData.count
        self.dataTotal = chartData.values.reduce(0, +)
        self.calculatedRadius = min(parentView.bounds.size.width, parentView.bounds.size.height)/2
        super.init(frame: frame)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(singleTap)
        
        parentView.addSubview(self)
    }
    
    //MARK: - Draw Chart Functions
    
    func displayChart()
    {
        var cumulativeValue = 0
        self.layer.sublayers = nil
        
        for i in 0..<numberOfSectors
        {
            let sectorLayer : CAShapeLayer = CAShapeLayer()
            let cumulativeProportion : CGFloat = CGFloat(chartData.values[i] + cumulativeValue) / CGFloat(dataTotal)
            let calculatedEndAngle : CGFloat = -0.5*CGFloat.pi + (2*CGFloat.pi) * cumulativeProportion
            let sectorFractionPath : UIBezierPath = UIBezierPath(arcCenter: center, radius: calculatedRadius/2, startAngle: -0.5*CGFloat.pi, endAngle: calculatedEndAngle, clockwise: true)
            
            cumulativeValue += chartData.values[i]
            
            sectorLayer.fillColor = UIColor.clear.cgColor

            sectorLayer.lineWidth = calculatedRadius
            sectorLayer.strokeColor = colourScheme[i].cgColor
            sectorLayer.path = sectorFractionPath.cgPath
            sectorLayer.zPosition = CGFloat(numberOfSectors - i).advanced(by: -1)
            
            self.layer.addSublayer(sectorLayer)
        }
    }
    
    func playChartAnimation()
    {
        var cumulativeValue = 0
        self.layer.sublayers = nil
        
        for i in 0..<numberOfSectors
        {
            let fillAnimation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            let sectorLayer : CAShapeLayer = CAShapeLayer()
            let cumulativeProportion : CGFloat = CGFloat(chartData.values[i] + cumulativeValue) / CGFloat(dataTotal)
            let calculatedEndAngle : CGFloat = -0.5*CGFloat.pi + (2*CGFloat.pi) * cumulativeProportion
            let sectorFractionPath : UIBezierPath = UIBezierPath(arcCenter: center, radius: calculatedRadius/2, startAngle: -0.5*CGFloat.pi, endAngle: calculatedEndAngle, clockwise: true)
            
            cumulativeValue += chartData.values[i]
            
            sectorLayer.fillColor = UIColor.clear.cgColor

            sectorLayer.lineWidth = calculatedRadius
            sectorLayer.strokeColor = chartData.colours[i].cgColor
            sectorLayer.path = sectorFractionPath.cgPath
            sectorLayer.zPosition = CGFloat(numberOfSectors - i).advanced(by: -1)
            
            fillAnimation.fromValue = 0
            fillAnimation.duration = 2
            fillAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            fillAnimation.fillMode = .forwards
            fillAnimation.isRemovedOnCompletion = false
            
            sectorLayer.add(fillAnimation, forKey: nil)
            self.layer.addSublayer(sectorLayer)
        }
    }
    
    //MARK: - TapGestureRecogniser Function
    
    @objc func handleTap()
    {
        playChartAnimation()
    }

}
*/


