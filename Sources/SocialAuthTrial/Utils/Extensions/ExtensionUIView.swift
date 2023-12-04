//
//  ExtensionUIView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 16/10/23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func enable(_ enable: Bool) {
        alpha = enable ? 1 : 0.5
        isUserInteractionEnabled = enable
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
}

extension UIView {
    
    enum Constraints: String {
        case top
        case bottom
        case leading
        case trailing
        case centerX
        case centerY
        case height
        case width
    }
    
    var safeAreaTop: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.topAnchor
    }
    
    var safeAreaBottom: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.bottomAnchor
    }
    
    var safeAreaLeading: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
    }
    
    var safeAreaTrailing: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.trailingAnchor
    }
    
    func constraint(_ constraint: Constraints) -> NSLayoutConstraint? {
        constraints.first(where: { $0.identifier == constraint.rawValue})
    }
    
    func makeConstraints(
        top: NSLayoutYAxisAnchor? = nil,
        bottom : NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        inset: CGFloat = 0)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            let topConstraint = topAnchor.constraint(equalTo: top, constant: inset)
            topConstraint.identifier = "top"
            topConstraint.isActive = true
        }
        if let bottom = bottom {
            let bottomConstraint = bottomAnchor.constraint(equalTo: bottom, constant: -inset)
            bottomConstraint.identifier = "bottom"
            bottomConstraint.isActive = true
        }
        if let leading = leading {
            let leadingConstraint = leadingAnchor.constraint(equalTo: leading, constant: inset)
            leadingConstraint.identifier = "leading"
            leadingConstraint.isActive = true
        }
        if let trailing = trailing {
            let trailingConstraint = trailingAnchor.constraint(equalTo: trailing, constant: -inset)
            trailingConstraint.identifier = "trailing"
            trailingConstraint.isActive = true
        }
        if let centerX = centerX {
            let centerXConstraint = centerXAnchor.constraint(equalTo: centerX , constant: inset)
            centerXConstraint.identifier = "centerX"
            centerXConstraint.isActive = true
        }
        if let centerY = centerY {
            let centerYConstraint = centerYAnchor.constraint(equalTo: centerY , constant: inset)
            centerYConstraint.identifier = "centerY"
            centerYConstraint.isActive = true
        }
        if let width = width {
            let widthConstraint = widthAnchor.constraint(equalToConstant: width)
            widthConstraint.identifier = "width"
            widthConstraint.isActive = true
        }
        if let height = height {
            let heightConstraint = heightAnchor.constraint(equalToConstant: height)
            heightConstraint.identifier = "height"
            heightConstraint.isActive = true
        }
    }
    
    func constraintXTo(view: UIView, inset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset)
        leadingConstraint.identifier = "leading"
        leadingConstraint.isActive = true
        
        let trailingConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
        trailingConstraint.identifier = "trailing"
        trailingConstraint.isActive = true
    }
    
    func edgesToSafeArea(_ safeAreaLayoutGuide: UILayoutGuide, inset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -inset).isActive = true
        leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset).isActive = true
        trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -inset).isActive = true
    }
    
    func edgesTo(_ superView: UIView, inset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: inset).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -inset).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: inset).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -inset).isActive = true
    }
    
}
