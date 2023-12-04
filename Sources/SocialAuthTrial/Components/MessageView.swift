//
//  MessageView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 31/10/23.
//

import UIKit

final class MessageView: UIStackView {
    
    // MARK: - Closures
    
    var onTapPrimaryButton: (() -> Void)?
    var onTapSecondaryButton: (() -> Void)?
    
    // MARK: - Private Properties
    
    private(set) lazy var imageView = UIImageView()
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
    }
    private(set) lazy var subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .grey300
    }
    private(set) lazy var stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 24
        $0.axis = .horizontal
    }
    private(set) lazy var primaryButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapPrimaryButton), for: .touchUpInside)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.primary100.cgColor
        $0.setTitleColor(.primary100, for: .normal)
        $0.makeConstraints(height: 43)
    }
    private(set) lazy var secondaryButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapSecondaryButton), for: .touchUpInside)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.setTitleColor(.primary100, for: .normal)
        $0.makeConstraints(height: 43)
    }
    
    // MARK: - Initialized
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        axis = .vertical
        spacing = 16
        alignment = .center
    }
    
    func updateUI(type: MessageType) {
        switch type {
        case let .basic(title, subtitle, image):
            updateUI(image: image, title: title, subtitle: subtitle)
        case let .withPrimaryButton(title, subtitle, button, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            addArrangedSubview(self.primaryButton)
            self.primaryButton.setTitle(button, for: .normal)
            primaryButton.makeConstraints(leading: self.leadingAnchor, trailing: self.trailingAnchor)
        case let .withVerticalSecondaryButton(title, subtitle, primaryButton, secondaryButton, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            addArrangedSubviews(self.primaryButton, self.secondaryButton)
            self.primaryButton.setTitle(primaryButton, for: .normal)
            self.secondaryButton.setTitle(secondaryButton, for: .normal)
        case let .withHorizontalSecondaryButton(title, subtitle, primaryButton, secondaryButton, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            addArrangedSubview(stackView)
            stackView.addArrangedSubviews(self.primaryButton, self.secondaryButton)
            self.primaryButton.setTitle(primaryButton, for: .normal)
            self.secondaryButton.setTitle(secondaryButton, for: .normal)
            
            setNeedsDisplay()
            layoutIfNeeded()
            let width = layoutXMargin() + spacing + frame.width / 2
            self.primaryButton.makeConstraints(width: width)
            self.secondaryButton.makeConstraints(width: width)
        case .customVertical:
            // TODO: implement later
            break
        }
    }
    
    private func updateUI(image: Image?, title: String, subtitle: NSAttributedString?) {
        if let image = image {
            loadImage(image: image)
            addArrangedSubview(imageView)
        }
        if !title.isEmpty {
            addArrangedSubview(titleLabel)
            titleLabel.text = title
        }
        if let subtitleString = subtitle?.string, !subtitleString.isEmpty {
            addArrangedSubview(subtitleLabel)
            subtitleLabel.attributedText = subtitle
        }
    }
    
    private func loadImage(image: Image) {
        switch image {
        case let .assets(image, size):
            imageView.image = image
            if let size = size {
                imageView.makeConstraints(width: size.width, height: size.height)
            }
        case let .url(url):
            // TODO: load image from URL
            break
        }
    }
    
    @objc private func tapPrimaryButton() {
        onTapPrimaryButton?()
    }
    
    @objc private func tapSecondaryButton() {
        onTapSecondaryButton?()
    }
    
}
