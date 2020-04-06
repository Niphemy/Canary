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
            var weeklyValues = Canary.weekdayTimings.values.map({ $0 })
            
            weeklyValues.removeAll(where: { $0 == 0 })
            
            if weeklyValues.isEmpty
            {
                return "0h 0m"
            }
            
            let weeklyAverage = weeklyValues.reduce(0, +)/weeklyValues.count
            let fractionalPart = (Float(weeklyAverage)/3600).truncatingRemainder(dividingBy: 1)
            
            return "\(weeklyAverage/3600)h \(Int(fractionalPart*60))m"
        }
    }
    
    private var statsBarChart = BarChartView()
    private var statsPieChart = PieChartView()
    
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
        setupPieChart()
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
        averageTimeLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 60).isActive = true
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
        let weeklyData = Canary.weekdayTimings
        
        let mon = DataPoint(value: Float(weeklyData["mon"]!), colour: .globalTintColor, title: "M")
        let tue = DataPoint(value: Float(weeklyData["tue"]!), colour: .globalTintColor, title: "T")
        let wed = DataPoint(value: Float(weeklyData["wed"]!), colour: .globalTintColor, title: "W")
        let thu = DataPoint(value: Float(weeklyData["thu"]!), colour: .globalTintColor, title: "T")
        let fri = DataPoint(value: Float(weeklyData["fri"]!), colour: .globalTintColor, title: "F")
        let sat = DataPoint(value: Float(weeklyData["sat"]!), colour: .globalTintColor, title: "S")
        let sun = DataPoint(value: Float(weeklyData["sun"]!), colour: .globalTintColor, title: "S")
        let tempData = [mon, tue, wed, thu, fri, sat, sun]
        statsBarChart = BarChartView(chartData: tempData, barSpacing: 10, stepLineCount: 2, chartColour: .dynamicTextColor)
         
        contentView.addSubview(statsBarChart)
        statsBarChart.translatesAutoresizingMaskIntoConstraints = false
        statsBarChart.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        statsBarChart.topAnchor.constraint(equalTo: averageTimeLabel.bottomAnchor, constant: 30).isActive = true
        statsBarChart.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        statsBarChart.heightAnchor.constraint(equalTo: statsBarChart.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    private func setupPieChart()
    {
        var data = [DataPoint]()
        
        for i in PlaytimeManager.getArtistTimingData()
        {
            data.append(DataPoint(value: i.value, colour: UIColor(), title: i.key))
        }
        
        statsPieChart = PieChartView(chartData: data)
        
        contentView.addSubview(statsPieChart)
        statsPieChart.translatesAutoresizingMaskIntoConstraints = false
        statsPieChart.leadingAnchor.constraint(equalTo: averageTimeLabel.leadingAnchor).isActive = true
        statsPieChart.topAnchor.constraint(equalTo: statsBarChart.bottomAnchor, constant: 10).isActive = true
        statsPieChart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        statsPieChart.widthAnchor.constraint(equalTo: statsPieChart.heightAnchor).isActive = true
        
        if let mostPlayed = statsPieChart.getMostPlayed()
        {
            setupPieChartInfo(mostPlayed: mostPlayed, totalTime: statsPieChart.dataTotal)
        }
        
    }
    
    private func setupPieChartInfo(mostPlayed: (String, Float), totalTime: Float)
    {
        let mostPlayedArtist = mostPlayed.0
        let mostPlayedValueInSeconds = mostPlayed.1
        let mostPlayedPercentageValue : Int = Int((mostPlayedValueInSeconds / totalTime)*100)
        let infoLabelText : String = "You listened to \(mostPlayedArtist) for \(Int(mostPlayedValueInSeconds/60))m this week which makes up \(mostPlayedPercentageValue)% of your total listening time since Monday"
        let textAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.montserratLight,NSAttributedString.Key.foregroundColor : UIColor.dynamicTextColor]
        
        let infoLabel = UILabel()
        let attributedText : NSAttributedString = NSAttributedString(string: infoLabelText, attributes: textAttributes)
        
        infoLabel.attributedText = attributedText
        
        contentView.addSubview(infoLabel)
        infoLabel.numberOfLines = 5
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(equalTo: statsPieChart.trailingAnchor, constant: 20).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: statsBarChart.trailingAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: statsPieChart.topAnchor).isActive = true
    }
}
