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
    private let averageTimeLabel = UILabel()
    private var dailyAverageString : String
    {
        get
        {
            var weeklyValues = UIApplication.weekdayTimings.values.map({ $0 })
            
            var endCase = true
            
            while endCase
            {
                for i in 0..<weeklyValues.count
                {
                    if weeklyValues[i] == 0
                    {
                        weeklyValues.remove(at: i)
                        break
                    }
                    
                    if i == weeklyValues.count - 1
                    {
                        endCase = false
                    }
                }
            }
            
            let weeklyAverage = weeklyValues.reduce(0, +)/weeklyValues.count
            
            let fractionalPart = (Float(weeklyAverage)/3600).truncatingRemainder(dividingBy: 1)
            
            return "\(weeklyAverage/3600)h \(Int(fractionalPart*60))m"
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        setupLabels()
        setupBarChart()
    }
    
    private func setupLabels()
    {
        let textAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratRegular.withSize(20),NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor]
        
        let textUnderlayLayer = CAShapeLayer()
        let underlayLayerRectangle = CGRect(origin: contentView.bounds.origin, size: CGSize(width: contentView.bounds.width, height: contentView.bounds.height*0.12))
        textUnderlayLayer.path = UIBezierPath(rect: underlayLayerRectangle).cgPath
        textUnderlayLayer.fillColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        contentView.layer.addSublayer(textUnderlayLayer)
        
        let titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: underlayLayerRectangle.height/2).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17).isActive = true
        titleLabel.attributedText = NSAttributedString(string: "Your listening stats", attributes: textAttributes)
        
        contentView.addSubview(averageTimeLabel)
        averageTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: underlayLayerRectangle.height + 10).isActive = true
        averageTimeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        averageTimeLabel.numberOfLines = 2
        
        let averageTimeText : NSMutableAttributedString =
        {
            let tempTimeText = NSMutableAttributedString()
            let dailyAverageAttribrutes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratLight.withSize(16),NSAttributedString.Key.foregroundColor : UIColor.systemGray]
            let actualTimeAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratMedium.withSize(20),NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor]
            let dailyAverageText = NSAttributedString(string: "Daily Average", attributes: dailyAverageAttribrutes)
            let actualTimeText = NSAttributedString(string: "\n\(dailyAverageString)", attributes: actualTimeAttributes)
            tempTimeText.append(dailyAverageText)
            tempTimeText.append(actualTimeText)
            return tempTimeText
        }()
        
        averageTimeLabel.attributedText = averageTimeText
    }
    
    private func setupBarChart()
    {
        let weeklyData = UIApplication.weekdayTimings
        
        let mon = DataPoint(value: Float(weeklyData["mon"]!), colour: .globalTintColor, title: "M")
        let tue = DataPoint(value: Float(weeklyData["tue"]!), colour: .globalTintColor, title: "T")
        let wed = DataPoint(value: Float(weeklyData["wed"]!), colour: .globalTintColor, title: "W")
        let thu = DataPoint(value: Float(weeklyData["thu"]!), colour: .globalTintColor, title: "T")
        let fri = DataPoint(value: Float(weeklyData["fri"]!), colour: .globalTintColor, title: "F")
        let sat = DataPoint(value: Float(weeklyData["sat"]!), colour: .globalTintColor, title: "S")
        let sun = DataPoint(value: Float(weeklyData["sun"]!), colour: .globalTintColor, title: "S")
        let tempData = [mon, tue, wed, thu, fri, sat, sun]
        let barChart = BarChartView(chartData: tempData, barSpacing: 10, stepLineCount: 2, chartColour: .dynamicTextColor)
            
        contentView.addSubview(barChart)
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        barChart.topAnchor.constraint(equalTo: averageTimeLabel.bottomAnchor, constant: 30).isActive = true
        barChart.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        barChart.heightAnchor.constraint(equalTo: barChart.widthAnchor, multiplier: 0.6).isActive = true
    }
}
