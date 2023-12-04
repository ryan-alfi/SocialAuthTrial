//
//  ToastView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 01/11/23.
//

import UIKit

final class ToastView: UIStackView {
    
    private let textLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.alignment = .center
        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = .horizontal
        self.spacing = 8
        self.backgroundColor = UIColor.black200.withAlphaComponent(0.9)
        self.alpha = 1.0
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grey400.cgColor
        self.clipsToBounds  =  true
    }
    
    func updateUI(image: UIImage?, imageSize: CGSize = CGSize(width: 18, height: 18), text: String) {
        if let image = image {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.makeConstraints(width: imageSize.width, height: imageSize.height)
            addArrangedSubview(imageView)
        }
        textLabel.text = text
        addArrangedSubview(textLabel)
    }
    
}
