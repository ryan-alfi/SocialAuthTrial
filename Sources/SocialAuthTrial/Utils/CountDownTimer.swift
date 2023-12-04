//
//  CountDownTimer.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 31/10/23.
//

import Foundation

class CountDownTimer {
    
    var onCountDownFinished: (() -> Void)?
    var onRepeats: ((TimeInterval) -> Void)?
    
    private var timer: Timer?
    private var interval: TimeInterval = 1
    private var maxInterval: TimeInterval = 0
    private var currentInterval: TimeInterval = 0
    
    private func createTimer(interval: TimeInterval) {
        timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: (#selector(updateTimer)),
            userInfo: nil,
            repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer(interval: TimeInterval = 1, maxInterval: TimeInterval) {
        self.interval = interval
        self.maxInterval = maxInterval
        removeTimer()
        createTimer(interval: interval)
        updateTimer()
    }
    
    @objc private func updateTimer() {
        currentInterval += 1
        onRepeats?(currentInterval)
        if currentInterval >= maxInterval {
            removeTimer()
            onCountDownFinished?()
        }
    }
    
}
