//
//  ExtensionUITableView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

extension UITableView {
    
    func getEstimationRowHeight() -> CGFloat {
        var height: CGFloat = 0
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                height += rectForRow(at: indexPath).size.height
            }
        }
        
        return height
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
}
