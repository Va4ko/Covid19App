//
//  CountingLabel.swift
//  Covid19App
//
//  Created by Vachko on 9.11.20.
//

import UIKit

class CountingLabel: UILabel {
    
    enum CounterAnimationType {
        case Linear
        case EaseIn
        case EaseOut
    }
    
    enum CounterType {
        case Int
        case Float
    }
    
    var startNumber: Float = 0.0
    var endNumber: Float = 0.0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    var counterAnimationType: CounterAnimationType!
    var counterType: CounterType!
    let counterVelocity: Float = 3.0
    
    var timer: Timer?
    
    var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
    }
    
    func count(fromValue: Float, to toValue: Float, withDuration duration: TimeInterval, AnimationType animationType: CounterAnimationType, andCounterType counterType: CounterType) {
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterAnimationType = animationType
        self.counterType = counterType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        invalidateTimer()
        
        if duration == 0 {
            updateText(value: toValue)
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CountingLabel.updateValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        
        updateText(value: currentCounterValue)
    }
    
    func updateText(value: Float) {
        switch counterType! {
        case .Int:
            self.text = "\(Int(value).formattedWithSeparator)"
        case .Float:
            self.text = String(format: "@.2f", value)
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCounter(counterValue: Float) -> Float {
        switch counterAnimationType! {
        case .Linear:
            return counterValue
        case .EaseIn:
            return powf(counterValue, counterVelocity)
        case .EaseOut:
            return 1.0 - powf(1.0 - counterValue, counterVelocity)
        }
    }
    
}
