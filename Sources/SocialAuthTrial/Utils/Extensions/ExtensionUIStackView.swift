//
//  ExtensionUIStackView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 16/10/23.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
    func layoutXMargin() -> CGFloat {
        return layoutMargins.right + layoutMargins.left
    }
    
    func layoutYMargin() -> CGFloat {
        return layoutMargins.top + layoutMargins.bottom
    }
    
}
