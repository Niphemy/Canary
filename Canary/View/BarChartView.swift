//
//  BarChartView.swift
//  test
//
//  Created by Nifemi Fatoye on 26/08/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

/*
class BarChartView: UIView
{
    //MARK: - Variables
    
    let barsStackView : UIStackView = UIStackView()
    private let chartData : DataSet
    
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
            return (bounds.width - CGFloat((numberOfBars+1)*spacing))/CGFloat(numberOfBars)
        }
    }
    
    private let chartColour : UIColor
    private let stepLineCount = 2
    private let spacing = 10
    
    //MARK: - Initialisers
    
    init(chartData : DataSet, chartColour : UIColor = UIColor.white)
    {
        self.chartData = chartData
        self.chartColour = chartColour
        
        super.init(frame: CGRect())
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(singleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Draw Chart Functions
    
    override func layoutSubviews()
    {
        setupAxes()
        
        //let max = getStepSize(data: chartData.values,steps: stepLineCount) * stepLineCount
        let barView = UIView()
        addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        barView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        barView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        /*
        for i in 0..<chartData.count
        {
            let bar = CAShapeLayer()
            let proportionalHeight : CGFloat = CGFloat(chartData.values[i])/CGFloat(max) * bounds.height
            
            bar.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        }
        */
    }
    
    func displayChart()
    {
        clearView()
        setupAxes()
        
        addSubview(barsStackView)
        
        barsStackView.distribution = .fillEqually
        barsStackView.alignment = .bottom
        barsStackView.axis = .horizontal
        barsStackView.spacing = 10
        barsStackView.translatesAutoresizingMaskIntoConstraints = false
        barsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        barsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        barsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        let max = getStepSize(data: chartData.values,steps: stepLineCount) * stepLineCount
        
        for i in 0..<chartData.count
        {
            let bar = UIView()
            let proportionalHeight : CGFloat = CGFloat(chartData.values[i])/CGFloat(max) * bounds.height
            
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.heightAnchor.constraint(equalToConstant: proportionalHeight).isActive = true
            bar.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            bar.layer.cornerRadius = 10
            bar.backgroundColor = UIColor.red
            
            barsStackView.addArrangedSubview(bar)
        }
    }
    
    func playChartAnimation(with duration : CFTimeInterval = 1)
    {
        clearView()
        setupAxes()
        
        let barsStackView : UIStackView = UIStackView()
        addSubview(barsStackView)
        
        barsStackView.distribution = .fillEqually
        barsStackView.alignment = .bottom
        barsStackView.axis = .horizontal
        barsStackView.spacing = 10
        barsStackView.translatesAutoresizingMaskIntoConstraints = false
        barsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        barsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        barsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        
        let preTopAnchor = barsStackView.topAnchor.constraint(equalTo: barsStackView.bottomAnchor)
        let postTopAnchor = barsStackView.topAnchor.constraint(equalTo: topAnchor)
        
        preTopAnchor.isActive = true
        
        var proportionalHeights = [CGFloat]()
        var anchors = [NSLayoutConstraint]()
        
        for i in 0..<chartData.count
        {
            let bar = UIView()
            let max = getStepSize(data: chartData.values,steps: stepLineCount) * stepLineCount
            let preHeightAnchor =  bar.heightAnchor.constraint(equalToConstant: 0)
            
            proportionalHeights.append(CGFloat(chartData.values[i])/CGFloat(max) * bounds.height)
            barsStackView.addArrangedSubview(bar)
            
            bar.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            bar.layer.cornerRadius = 10
            bar.backgroundColor = chartData.colours[i]
            bar.translatesAutoresizingMaskIntoConstraints = false
            
            preHeightAnchor.isActive = true
            anchors.append(preHeightAnchor)
        }
        
        layoutIfNeeded()
        
        for i in 0..<chartData.count
        {
            anchors[i].constant = proportionalHeights[i]
        }

        preTopAnchor.isActive = false
        postTopAnchor.isActive = true
        
        UIView.animate(withDuration: duration)
        {
            self.layoutIfNeeded()
        }
    }
    
    private func setupAxes()
    {
        let bottomLeft : CGPoint = .init(x: frame.minX + 40, y: frame.maxY)
        let bottomRight : CGPoint = .init(x: frame.maxX - 10, y: frame.maxY)
        
        let xAxis = UIBezierPath()
        xAxis.move(to:  bottomLeft)
        xAxis.addLine(to: bottomRight)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = xAxis.cgPath
        backgroundLayer.lineWidth = 2
        backgroundLayer.strokeColor = chartColour.cgColor
        backgroundLayer.lineCap = .round
        
        layer.addSublayer(backgroundLayer)
        
        for i in 0...stepLineCount
        {
            drawLines(i)
            drawScales(i)
        }
    }
    
    private func drawLines(_ iterator: Int)
    {
        let beginning = CGPoint(x: frame.minX + 40 , y: bounds.height * (CGFloat(iterator)/CGFloat(stepLineCount)))
        let end = CGPoint(x: frame.maxX - 10, y: beginning.y)
   
        let stepLine = UIBezierPath()
        stepLine.move(to: beginning)
        stepLine.addLine(to: end)
        
        let stepLayer = CAShapeLayer()
        stepLayer.path = stepLine.cgPath
        stepLayer.lineWidth = 0.5
        stepLayer.strokeColor = chartColour.cgColor
        stepLayer.lineCap = .round
        stepLayer.lineDashPattern = [2,2]
        
        layer.addSublayer(stepLayer)
    }
    
    private func drawScales(_ iterator: Int)
    {
        let title = UILabel()
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints =  false
        
        let scaleSize = getStepSize(data: chartData.values, steps: stepLineCount)
        
        title.text = "\(scaleSize * (iterator))"
        title.textAlignment = .center
        title.textColor = chartColour
        title.font = UIFont(name: "Helvetica-Bold", size: 13)
        title.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -(frame.height * CGFloat(iterator)/CGFloat(stepLineCount))).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    private func getStepSize(data : [Int], steps : Int) -> Int
    {
        guard let max = data.max() else { fatalError() }
        
        let tempStep: Float = Float(max) / Float(steps)
        let mag: Float = floor(log10(tempStep))
        let magPow: Float = pow(10, mag)
        var magMsd: Float = (tempStep / magPow + 0.5)
        
        if magMsd > 5
        {
            magMsd = 10
        }else if magMsd > 2
        {
            magMsd = 5
        }else if magMsd > 1
        {
            magMsd = 2
        }
        return Int(magMsd * magPow)
    }
    
    func clearView()
    {
        for view in subviews
        {
            view.removeFromSuperview()
        }
        
        layer.sublayers = nil
    }
    
    //MARK: - TapGestureRecogniser Function
    
    @objc private func handleTap()
    {
        playChartAnimation()
    }
}
*/
