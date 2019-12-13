//
//  MusicProgressTracker.swift
//  Canary
//
//  Created by Nifemi Fatoye on 13/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit

class MusicProgressTracker : UIView
{
    private let slider = UISlider()
    private let currentTimeLabel = UILabel()
    private let remainingTimeLabel = UILabel()
    
    required init?(coder: NSCoder){fatalError("init(coder:) has not been implemented")}
    
    init()
    {
        super.init(frame: CGRect())
        
        
        
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    override func layoutSubviews()
    {
        addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        addSubview(remainingTimeLabel)
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: remainingTimeLabel.leadingAnchor).isActive = true
    }
    
    private func setDurationLabels(duration: TimeInterval)
    {
        let integerDuration : Int = Int(duration.rounded())
        var durationComponents : (hours: Int, minutes: Int, seconds: Int) = (integerDuration / 3600, (integerDuration % 3600) / 60, integerDuration % 60)
    }
    
    @objc private func sliderDidEndEditing()
    {
        
    }
    
    @objc private func sliderValueChanged()
    {
        
    }
}
