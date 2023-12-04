//
//  Image.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 31/10/23.
//

import UIKit

enum Image {
    /// image from assets Resources
    case assets(image: UIImage?, size: CGSize? = nil)
    /// image from url
    case url(url: String)
}
