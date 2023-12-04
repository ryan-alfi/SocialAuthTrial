//
//  CountDownLabel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 30/10/23.
//

import Foundation
import UIKit

final class CountDownLabel: UILabel {
    
    var onCountdownFinished: (() -> Void)?
    
    private var timer: Timer?
    private var diffDate: Date?
    private var startDate = Date()
    private let date1970 = Date(timeIntervalSince1970: 0)
    private var maxInterval: TimeInterval = 0
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = Foundation.TimeZone(abbreviation: "GMT")
        formatter.dateFormat = timeFormat
        return formatter
    }
    
    var timeFormat: String {
        return (maxInterval - intervalCounted) >= 3600 ? "hh : mm : ss" : "mm : ss"
    }
    var prefixText: String = ""
    var countdownColor = UIColor.grey300
    var prefixColor = UIColor.grey300
    var countdownFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    var prefixFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    private var intervalCounted: TimeInterval {
        let timeCounted = Date().timeIntervalSince(startDate)
        return round(timeCounted < 0 ? 0 : timeCounted)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        removeTimer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func reformatTime(_ toDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        var labelText = timeFormat
        let comp = calendar.dateComponents([.day, .hour, .minute, .second], from: date1970 as Date, to: toDate)
        
        if let day = comp.day ,let _ = timeFormat.range(of: "dd"){
            labelText = labelText.replacingOccurrences(of: "dd", with: String(format: "%02ld", day))
        }
        if let hour = comp.hour ,let _ = timeFormat.range(of: "hh"){
            labelText = labelText.replacingOccurrences(of: "hh", with: String(format: "%02ld", hour))
        }
        if let hour = comp.hour ,let _ = timeFormat.range(of: "HH"){
            labelText = labelText.replacingOccurrences(of: "HH", with: String(format: "%02ld", hour))
        }
        if let minute = comp.minute ,let _ = timeFormat.range(of: "mm"){
            labelText = labelText.replacingOccurrences(of: "mm", with: String(format: "%02ld", minute))
        }
        if let second = comp.second ,let _ = timeFormat.range(of: "ss"){
            labelText = labelText.replacingOccurrences(of: "ss", with: String(format: "%02ld", second))
        }
        return labelText
    }
    
    func startTimer(startDate: Date = Date(), interval: TimeInterval) {
        removeTimer()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        maxInterval = interval
        self.startDate = startDate
        self.diffDate = date1970.addingTimeInterval(interval)
        updateTimer()
    }
    
    @objc private func updateTimer() {
        guard let diffDate = diffDate else {
            return
        }
        let date = diffDate.addingTimeInterval(round(intervalCounted * -1))
        let formattedText = intervalCounted < 0 ? dateFormatter.string(from: date1970.addingTimeInterval(0)) : reformatTime(date)

        let attributedString = NSMutableAttributedString(
            string: prefixText + formattedText,
            attributes: [.font: prefixFont, .foregroundColor: prefixColor])
        
        attributedString.addAttributes([.font: countdownFont,.foregroundColor: countdownColor],
                                       range: NSRange(location: prefixText.count, length: formattedText.count))
        
        attributedText = attributedString
        
        if intervalCounted >= maxInterval {
            onCountdownFinished?()
            removeTimer()
        }
    }
    
}
