//
//  MusicProgressTracker.swift
//  Canary
//
//  Created by Nifemi Fatoye on 13/12/2019.
//  Copyright © 2019 Nifemi Fatoye. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicProgressTracker : UIView
{
    private let slider = UISlider()
    private let currentTimeLabel = UILabel()
    private let remainingTimeLabel = UILabel()
    private var viewUpdater = CADisplayLink()
    
    required init?(coder: NSCoder){fatalError("init(coder:) has not been implemented")}
    
    init()
    {
        super.init(frame: CGRect())
        
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchCancel)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        viewUpdater = CADisplayLink(target: self, selector: #selector(updateView))
        viewUpdater.add(to: .main, forMode: .default)
    }
    
    override func layoutSubviews()
    {
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
        currentTimeLabel.textAlignment = .left
        
        addSubview(remainingTimeLabel)
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.widthAnchor.constraint(equalTo: currentTimeLabel.widthAnchor).isActive = true
        remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        remainingTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
        remainingTimeLabel.textAlignment = .right
    }
    
    @objc private func updateView()
    {
        slider.value = Float(UIApplication.sharedAudioPlayer.currentTime() / UIApplication.sharedAudioPlayer.currentDuration())
        
        let currentTimeString = formatTime(time: UIApplication.sharedAudioPlayer.currentTime())
        let remainingTimeString = formatTime(time: UIApplication.sharedAudioPlayer.currentDuration() - UIApplication.sharedAudioPlayer.currentTime())
        
        let timeAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font : UIFont.montserratMedium]
        
        currentTimeLabel.attributedText = NSAttributedString(string: currentTimeString, attributes: timeAttributes)
        remainingTimeLabel.attributedText = NSAttributedString(string: remainingTimeString, attributes: timeAttributes)
    }
    
    @objc private func sliderDidEndEditing()
    {
        viewUpdater.isPaused = false
        let selectedTime = Double(slider.value)*UIApplication.sharedAudioPlayer.currentDuration()
        UIApplication.sharedAudioPlayer.seekTo(time: selectedTime)
    }
    
    @objc private func sliderValueChanged()
    {
        viewUpdater.isPaused = true
        
        let sliderCurrentTimeValue = Double(slider.value)*UIApplication.sharedAudioPlayer.currentDuration()
        let sliderRemainingTimeValue = UIApplication.sharedAudioPlayer.currentDuration() - sliderCurrentTimeValue
        
        let sliderCurrentTimeString = formatTime(time: sliderCurrentTimeValue)
        let sliderRemainingTimeString = formatTime(time: sliderRemainingTimeValue)
    
        let timeAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font : UIFont.montserratMedium]
        
        currentTimeLabel.attributedText = NSAttributedString(string: sliderCurrentTimeString, attributes: timeAttributes)
        remainingTimeLabel.attributedText = NSAttributedString(string: sliderRemainingTimeString, attributes: timeAttributes)
    }
    
    private func formatTime(time: TimeInterval) -> String
    {
        let integerTime = Int(time)
        var timeComponents = ["\(integerTime/3600)", "\((integerTime%3600)/60)", "\(integerTime%60)"]
        
        if timeComponents.first == "0"
        {
            timeComponents.removeFirst()
        }
        
        for i in 0..<timeComponents.count
        {
            if i != 0 && timeComponents[i].count <= 1
            {
                repeat
                {
                    timeComponents[i].insert("0", at: timeComponents[i].startIndex)
                }while timeComponents[i].count != 2
            }
        }
        
        return timeComponents.joined(separator: ":")
    }
}
