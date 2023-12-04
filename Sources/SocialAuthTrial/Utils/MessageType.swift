//
//  MessageType.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 01/11/23.
//

import UIKit

enum MessageType {
    /// title, subtitle, image
    case basic(
        title: String,
        subtitle: NSAttributedString?,
        image: Image? = nil)
    /// title, subtitle, primary button title, image
    case withPrimaryButton(
        title: String,
        subtitle: NSAttributedString?,
        button: String,
        image: Image? = nil)
    /// title, subtitle, primary button title, secondary button title, closeButton, image
    case withVerticalSecondaryButton(
        title: String,
        subtitle: NSAttributedString?,
        primaryButton: String,
        secondaryButton: String,
        image: Image? = nil)
    /// title, subtitle, primary button title, secondary button title, closeButton, image
    case withHorizontalSecondaryButton(
        title: String,
        subtitle: NSAttributedString?,
        primaryButton: String,
        secondaryButton: String,
        image: Image? = nil)
    case customVertical(
        title: String,
        subtitle: NSAttributedString?,
        primaryButton: ButtonStyle? = nil,
        secondaryButton: ButtonStyle? = nil,
        image: Image? = nil)
}

enum ButtonStyle {
    case primary(String)
    case secondary(String)
    case plain(String)
}

extension ButtonStyle {
    
    func applyStyle(to button: UIButton) {
        switch self {
        case .primary(let title):
            button.primaryStyle()
            button.setTitle(title, for: .normal)
        case .secondary(let title):
            button.secondaryStyle()
            button.setTitle(title, for: .normal)
        case .plain(let title):
            button.plainStyle()
            button.setTitle(title, for: .normal)
        }
    }
    
}
