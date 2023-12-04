//
//  ExtensionUINavigationController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

extension UINavigationController {

    func replace(to controller: UIViewController, animated: Bool = true, fade: Bool = true) {
        guard let current = self.topViewController else {
            return
        }
        
        var controllers = self.viewControllers
        controllers.remove(current)
        controllers.append(controller)
        
        if fade {
            let transition = CATransition()
            transition.duration = 0.1
            view.layer.add(transition, forKey: nil)
            self.setViewControllers(controllers, animated: false)
        }
        else {
            self.setViewControllers(controllers, animated: animated)
        }
    }

}

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}
