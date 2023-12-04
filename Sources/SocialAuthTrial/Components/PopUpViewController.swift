//
//  PopUpViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 01/11/23.
//

import UIKit

final class PopUpViewController: UIViewController {
    
    // MARK: - Closures
    
    var onTapPrimaryButton: (() -> Void)?
    var onTapSecondaryButton: (() -> Void)?
    
    private let containerStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.backgroundColor = .black500
        $0.layer.cornerRadius = 8
    }
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
        $0.primaryStyle()
        $0.addTarget(self, action: #selector(tapPrimaryButton), for: .touchUpInside)
    }
    private(set) lazy var secondaryButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapSecondaryButton), for: .touchUpInside)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.setTitleColor(.primary100, for: .normal)
        $0.makeConstraints(height: 43)
    }
    
    private var type: MessageType
    
    // MARK: - Initialized
    
    init(type: MessageType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(containerStackView)
        view.backgroundColor = .black.withAlphaComponent(0.8)
        containerStackView.constraintXTo(view: view, inset: AppConstants.insetX + 10)
        containerStackView.makeConstraints(centerY: view.centerYAnchor)
        configureUI()
    }
    
    func configureUI() {
        switch type {
        case let .basic(title, subtitle, image):
            updateUI(image: image, title: title, subtitle: subtitle)
        case let .withPrimaryButton(title, subtitle, button, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            containerStackView.addArrangedSubview(self.primaryButton)
            self.primaryButton.setTitle(button, for: .normal)
            primaryButton.constraintXTo(view: containerStackView, inset: 24)
        case let .withVerticalSecondaryButton(title, subtitle, primaryButton, secondaryButton, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            containerStackView.addArrangedSubviews(self.primaryButton, self.secondaryButton)
            self.primaryButton.setTitle(primaryButton, for: .normal)
            self.secondaryButton.setTitle(secondaryButton, for: .normal)
            self.primaryButton.constraintXTo(view: containerStackView, inset: 24)
            self.secondaryButton.constraintXTo(view: containerStackView, inset: 24)
        case let .withHorizontalSecondaryButton(title, subtitle, primaryButton, secondaryButton, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            containerStackView.addArrangedSubview(stackView)
            self.primaryButton.setTitle(primaryButton, for: .normal)
            self.secondaryButton.setTitle(secondaryButton, for: .normal)
            stackView.addArrangedSubviews(self.primaryButton, self.secondaryButton)
            
            view.setNeedsDisplay()
            view.layoutIfNeeded()
            let width = containerStackView.layoutXMargin() + containerStackView.spacing + containerStackView.frame.width / 2
            self.primaryButton.makeConstraints(width: width)
            self.secondaryButton.makeConstraints(width: width)
        case let .customVertical(title, subtitle, primaryButton, secondaryButton, image):
            updateUI(image: image, title: title, subtitle: subtitle)
            
            if let primaryButton = primaryButton {
                containerStackView.addArrangedSubview(self.primaryButton)
                primaryButton.applyStyle(to: self.primaryButton)
                self.primaryButton.constraintXTo(view: containerStackView, inset: 24)
            }
            if let secondaryButton = secondaryButton {
                containerStackView.addArrangedSubview(self.secondaryButton)
                secondaryButton.applyStyle(to: self.secondaryButton)
                self.secondaryButton.constraintXTo(view: containerStackView, inset: 24)
            }
        }
    }
    
    private func updateUI(image: Image?, title: String, subtitle: NSAttributedString?) {
        if let image = image {
            loadImage(image: image)
            containerStackView.addArrangedSubview(imageView)
        }
        if !title.isEmpty {
            containerStackView.addArrangedSubview(titleLabel)
            titleLabel.text = title
        }
        if let subtitleString = subtitle?.string, !subtitleString.isEmpty {
            containerStackView.addArrangedSubview(subtitleLabel)
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
        dismiss(animated: true) { [weak self] in
            self?.onTapPrimaryButton?()
        }
        
    }
    
    @objc private func tapSecondaryButton() {
        dismiss(animated: true) { [weak self] in
            self?.onTapSecondaryButton?()
        }
    }
    
}
