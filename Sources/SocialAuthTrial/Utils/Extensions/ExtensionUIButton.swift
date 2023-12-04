//
//  ExtensionUIButton.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

extension UIButton {
    
    func primaryStyle() {
        layer.cornerRadius = 5
        backgroundColor = .primary100
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        makeConstraints(height: 42)
    }
    
    func secondaryStyle() {
        layer.cornerRadius = 20
        layer.borderColor = UIColor.primary100.cgColor
        layer.borderWidth = 1
        setTitleColor(.primary100, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        makeConstraints(height: 42)
    }
    
    func plainStyle() {
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        setTitleColor(.primary100, for: .normal)
        makeConstraints(height: 43)
    }
}
